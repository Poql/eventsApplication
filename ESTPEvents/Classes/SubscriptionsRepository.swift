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

protocol SubscriptionRepository {
    associatedtype EnsureEventModificationSubscriptionOperation: Operation, EnsureEventModificationSubscriptionOperationPrototype
    associatedtype EnsureNotifyUserOnEventCreationOperation: Operation, EnsureNotifyUserOnEventCreationOperationPrototype

    func ensureEventsSubscriptionOperation() -> EnsureEventModificationSubscriptionOperation
    func ensureNotifyUserOnEventCreationOperation() -> EnsureNotifyUserOnEventCreationOperation
}
