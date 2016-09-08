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

class ApplicationPresenterImplementation<PR: PersistencyRepository, SR: SubscriptionRepository>: ApplicationPresenter {
    let operationQueue = OperationQueue()
    let persistencyRepository: PR
    let subscriptionRepository: SR
    
    init(persistencyRepository: PR, subscriptionRepository: SR) {
        self.persistencyRepository = persistencyRepository
        self.subscriptionRepository = subscriptionRepository
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
        operation.addCompletionBlockOnMainQueue {
            if let event = operation.resultingRecord as? Event {
                persistEventOperation.events = [event]
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
}
