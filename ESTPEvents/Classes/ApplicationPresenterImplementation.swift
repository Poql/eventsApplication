//
//  ApplicationPresenterImplementation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 07/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations
import CloudKit

class ApplicationPresenterImplementation<PR: PersistencyRepository, SR: SubscriptionRepository, USR: UserStatusRepository>: ApplicationPresenter {
    let operationQueue = OperationQueue()

    let persistencyRepository: PR
    let subscriptionRepository: SR
    let userStatusRepository: USR

    private var listeners = WeakList<UserStatusUpdateListener>()

    var currentUserStatus: UserStatus {
        return NSUserDefaults.standardUserDefaults().userStatus() ?? .follower
    }

    init(persistencyRepository: PR, subscriptionRepository: SR, userStatusRepository: USR) {
        self.persistencyRepository = persistencyRepository
        self.subscriptionRepository = subscriptionRepository
        self.userStatusRepository = userStatusRepository
    }

    func deleteEvents(beforeDate date: NSDate) {
        let operation = persistencyRepository.deleteEventsOperation(limitDate: date)
        operationQueue.addOperation(operation)
    }
    
    func ensureNotifications() {
        let eventOperation = subscriptionRepository.ensureEventsSubscriptionOperation()
        let userEventOperation = subscriptionRepository.ensureNotifyUserOnEventCreationOperation()
        operationQueue.addOperations(eventOperation, userEventOperation)
    }
    
    func handleRemoteNotification(withUserInfo userInfo: [NSObject : AnyObject], completionHandler: (UIBackgroundFetchResult) -> Void) {
        guard let userInfo = userInfo as? [String : NSObject] else { return }
        let notification = CKQueryNotification(fromRemoteNotificationDictionary: userInfo)
        guard let recordID = notification.recordID else { return }
        let operation = subscriptionRepository.fetchRecordOperation(recordName: recordID.recordName)
        let persistEventOperation = persistencyRepository.persistEventsOperation()
        (persistEventOperation as Operation).addDependency(operation)
        operation.addWillFinishBlock {
            if let event = operation.resultingRecord as? Event {
                persistEventOperation.events = [event]
            }
            else if let admin = operation.resultingRecord as? Admin {
                dispatch_async(dispatch_get_main_queue()) {
                    self.handleUserStatusFetch(UserStatus(admin: admin))
                }
            }
        }
        let group = GroupOperation(operations: operation, persistEventOperation)
        group.addCompletionBlockOnMainQueue {
            if !group.errors.isEmpty {
                completionHandler(.Failed)
            } else {
                completionHandler(.NewData)
            }
        }
        operationQueue.addOperations(operation, persistEventOperation)
    }

    func checkUserStatus() {
        let operation = userStatusRepository.fetchUserStatusOperation()
        operation.addCompletionBlockOnMainQueue {
            guard operation.errors.isEmpty else { return }
            self.handleUserStatusFetch(operation.userStatus)
        }
        operationQueue.addOperation(operation)
    }

    func registerForUserStatusUpdate(listener: UserStatusUpdateListener) {
        listeners.insert(listener)
    }

    // MARK: - Private

    private func handleUserStatusFetch(change: UserStatus) {
        if let change = checkUserStatusChange(forNew: change) {
            for listener in self.listeners {
                listener.userStatusDidUpdate(change)
            }
        }
    }

    private func checkUserStatusChange(forNew userStatus: UserStatus) -> UserStatus? {
        if let currentUserStatus = NSUserDefaults.standardUserDefaults().userStatus() where currentUserStatus == userStatus {
            return nil
        }
        NSUserDefaults.standardUserDefaults().set(userStatus: userStatus)
        return userStatus
    }
}
