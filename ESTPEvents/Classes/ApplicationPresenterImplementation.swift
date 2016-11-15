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
    let persistentQueue = PersistentOperationQueue.shared

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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleStatusChangeNotification(_:)), name: CKAccountChangedNotification, object: nil)
    }

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    func deleteEvents(beforeDate date: NSDate) {
        let operation = persistencyRepository.deleteEventsOperation(limitDate: date)
        persistentQueue.addOperation(operation)
    }

    func deleteMessages(beforeDate date: NSDate) {
        let operation = persistencyRepository.deleteMessagesOperation(limitDate: date)
        persistentQueue.addOperation(operation)
    }
    
    func ensureNotifications() {
        sendSuscriptions()
        tryToSendAuthenticatedSubscriptions()
    }
    
    func handleRemoteNotification(withUserInfo userInfo: [NSObject : AnyObject], completionHandler: (UIBackgroundFetchResult) -> Void) {
        guard let userInfo = userInfo as? [String : NSObject] else { return }
        let notification = CKQueryNotification(fromRemoteNotificationDictionary: userInfo)
        guard let recordID = notification.recordID else { return }
        let operation = subscriptionRepository.fetchRecordOperation(recordName: recordID.recordName)
        let persistEventOperation = persistencyRepository.persistEventsOperation()
        (persistEventOperation as Operation).addDependency(operation)
        let persistMessagesOperation = persistencyRepository.persistMessagesOperation()
        (persistMessagesOperation as Operation).addDependency(operation)
        operation.addWillFinishBlock {
            if let event = operation.resultingRecord as? Event {
                persistEventOperation.events = [event]
                (persistMessagesOperation as Operation).cancel()
            }
            else if let message = operation.resultingRecord as? Message {
                persistMessagesOperation.messages = [message]
                (persistEventOperation as Operation).cancel()
            }
            else if let admin = operation.resultingRecord as? Admin {
                dispatch_async(dispatch_get_main_queue()) {
                    self.handleUserStatusFetch(UserStatus(admin: admin))
                }
            }
        }
        let group = GroupOperation(operations: persistMessagesOperation, persistEventOperation)
        group.addCompletionBlockOnMainQueue {
            if !group.errors.isEmpty {
                completionHandler(.Failed)
            } else {
                completionHandler(.NewData)
            }
        }
        persistentQueue.addOperation(group)
        operationQueue.addOperations(operation)
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

    private func sendSuscriptions() {
        let eventOperation = subscriptionRepository.ensureEventsSubscriptionOperation()
        let userEventOperation = subscriptionRepository.ensureNotifyUserOnEventCreationOperation()
        let messagesOperation = subscriptionRepository.ensureMessageSubscriptionOperation()
        let userMessageOperation = subscriptionRepository.ensureNotifyUserOnMessageCreationOperation()
        operationQueue.addOperations(userEventOperation, eventOperation, messagesOperation, userMessageOperation)
    }

    private func resetAuthenticatedSubscriptionsKeys() {
        subscriptionRepository.resetAuthenticatedSubscriptionsKeys()
    }

    private func tryToSendAuthenticatedSubscriptions() {
        CKContainer.current().accountStatusWithCompletionHandler { status, error in
            self.handleCloudUserStausFetch(status)
        }
    }

    private func sendAuthenticatedSubscriptions() {
        let adminUpdateOperation = subscriptionRepository.ensureAdminModificationSubscriptionOperation()
        let userAdminUpdateOperation = subscriptionRepository.ensureNotifyUserOnAdminValidationOperation()
        operationQueue.addOperations(adminUpdateOperation, userAdminUpdateOperation)
    }

    @objc private func handleStatusChangeNotification(notification: NSNotification) {
        tryToSendAuthenticatedSubscriptions()
    }

    private func handleUserStatusFetch(change: UserStatus) {
        if let change = checkUserStatusChange(forNew: change) {
            for listener in self.listeners {
                listener.userStatusDidUpdate(change)
            }
        }
    }

    private func handleCloudUserStausFetch(status: CKAccountStatus) {
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let currentStatus = userDefaults.getAccountStatus()
        userDefaults.set(accountStatus: status)
        switch status {
        case .Available:
            if currentStatus != status {
                resetAuthenticatedSubscriptionsKeys()
            }
            sendAuthenticatedSubscriptions()
        default:
            return
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
