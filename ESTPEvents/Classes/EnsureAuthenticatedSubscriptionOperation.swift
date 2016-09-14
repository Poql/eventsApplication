//
//  EnsureAuthenticatedSubscriptionOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 14/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Operations
import CloudKit

class AuthenticatedEnsureSubscriptionOperation<R: Record>: AuthenticationProviderOperation {
    private let ensureAuthenticatedSubscriptionOperation: EnsureAuthenticatedSubscriptionOperation<R>
    var authenticatedPredicate: ((userID: CKRecordID) -> NSPredicate?)? {
        set {
            ensureAuthenticatedSubscriptionOperation.authenticatedPredicate = newValue
        }
        get {
            return ensureAuthenticatedSubscriptionOperation.authenticatedPredicate
        }
    }
    var notificationInfo: CKNotificationInfo? {
        set {
            ensureAuthenticatedSubscriptionOperation.notificationInfo = newValue
        }
        get {
            return ensureAuthenticatedSubscriptionOperation.notificationInfo
        }
    }
    init(key: String, options: CKSubscriptionOptions) {
        ensureAuthenticatedSubscriptionOperation = EnsureAuthenticatedSubscriptionOperation(key: key, options: options)
        super.init()
        addAuthenticatedOperation(ensureAuthenticatedSubscriptionOperation)
    }
}

class EnsureAuthenticatedSubscriptionOperation<R: Record>: EnsureSubscriptionOperation<R>, AuthenticatedOperation {
    var userID: CKRecordID?

    var authenticatedPredicate: ((userID: CKRecordID) -> NSPredicate?)?

    init(key: String, options: CKSubscriptionOptions) {
        super.init(predicate: NSPredicate.alwaysTrue(), key: key, options: options)
        addCondition(AuthenticatedCondition())
    }

    override func execute() {
        if let userID = userID, let predicate = authenticatedPredicate?(userID: userID) {
            let newSubscription = CKSubscription(recordType: R.name, predicate: predicate, options: subscription.subscriptionOptions)
            newSubscription.notificationInfo = subscription.notificationInfo
            subscription = newSubscription
        }
        super.execute()
    }
}
