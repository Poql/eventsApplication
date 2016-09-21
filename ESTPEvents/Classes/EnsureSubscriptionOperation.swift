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

class EnsureSubscriptionOperation<R: Record>: ModifySubscriptionsOperation {
    var subscription: CKSubscription

    let key: String

    var notificationInfo: CKNotificationInfo? {
        set {
            subscription.notificationInfo = newValue
        }
        get {
            return subscription.notificationInfo
        }
    }
    
    init(predicate: NSPredicate, key: String, options: CKSubscriptionOptions) {
        self.subscription = CKSubscription(recordType: R.name, predicate: predicate, options: options)
        self.key = key
        super.init(subscriptionsToSave: [subscription], subscriptionIDsToDelete: nil)
        addCondition(NewSubscriptionCondition(subscriptionKey: key))
    }

    override func operationDidFinish(errors: [ErrorType]) {
        if let error = errors.first as? NSError, let partialErrors = error.partialErrors() {
            for (id, partialError) in partialErrors {
                // that means the subscription has already been saved
                if partialError == CKErrorCode.ServerRejectedRequest {
                    NSUserDefaults.standardUserDefaults().saveSubscriptionID(id, forKey: key)
                    return
                }
            }
        }
        if let error = errors.first as? OperationError where error == .subscriptionAlreadySubmitted || errors.isEmpty {
            NSUserDefaults.standardUserDefaults().saveSubscriptionID(savedSubscriptions?.first?.subscriptionID, forKey: key)
            return
        }
        NSUserDefaults.standardUserDefaults().saveSubscriptionID(nil, forKey: key)
    }
}
