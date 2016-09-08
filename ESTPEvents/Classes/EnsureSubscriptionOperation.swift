//
//  EnsureSubscriptionOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 08/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations
import CloudKit

class NewSubscriptionCondition: Condition {
    let subscriptionKey: String

    init(subscriptionKey: String) {
        self.subscriptionKey = subscriptionKey
        super.init()
    }

    override func evaluate(operation: Operation, completion: CompletionBlockType) {
        let newSubscription = NSUserDefaults.standardUserDefaults().getSubscriptionID(forKey: subscriptionKey) == nil
        if newSubscription {
            completion(.Satisfied)
            return
        }
        completion(.Failed(OperationError.subscriptionAlreadySubmitted))
    }
}
