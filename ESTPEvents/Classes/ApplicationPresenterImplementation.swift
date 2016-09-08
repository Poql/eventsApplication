//
//  ApplicationPresenterImplementation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 07/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations

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
}
