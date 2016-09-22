//
//  SubscriptionsRepository.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 08/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations

protocol EnsureEventModificationSubscriptionOperationPrototype {
}

protocol EnsureNotifyUserOnEventCreationOperationPrototype {
}

protocol EnsureAdminModificationSubscriptionOperationPrototype {
}

protocol EnsureNotifyUserOnAdminValidationOperationPrototype {
}

protocol FetchRecordOperationPrototype {
    var resultingRecord: Record? { get }
}

protocol SubscriptionRepository {
    associatedtype EnsureAdminModificationSubscriptionOperation: Operation, EnsureAdminModificationSubscriptionOperationPrototype
    associatedtype EnsureNotifyUserOnAdminValidationOperation: Operation, EnsureNotifyUserOnAdminValidationOperationPrototype
    associatedtype EnsureEventModificationSubscriptionOperation: Operation, EnsureEventModificationSubscriptionOperationPrototype
    associatedtype EnsureNotifyUserOnEventCreationOperation: Operation, EnsureNotifyUserOnEventCreationOperationPrototype
    associatedtype FetchRecordOperation: Operation, FetchRecordOperationPrototype

    func resetAuthenticatedSubscriptionsKeys()

    func ensureNotifyUserOnAdminValidationOperation() -> EnsureNotifyUserOnAdminValidationOperation
    func ensureAdminModificationSubscriptionOperation() -> EnsureAdminModificationSubscriptionOperation
    
    func ensureEventsSubscriptionOperation() -> EnsureEventModificationSubscriptionOperation
    func ensureNotifyUserOnEventCreationOperation() -> EnsureNotifyUserOnEventCreationOperation
    func fetchRecordOperation(recordName recordName: String) -> FetchRecordOperation
}
