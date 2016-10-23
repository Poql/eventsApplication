//
//  ModifySubscriptionsOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 08/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import CloudKit

class ModifySubscriptionsOperation: CloudOperation {

    private let subscriptionsOperation: CKModifySubscriptionsOperation

    var subscriptionsToSave: [CKSubscription]? {
        set {
            subscriptionsOperation.subscriptionsToSave = newValue
        }
        get {
            return subscriptionsOperation.subscriptionsToSave
        }
    }
    
    var subscriptionIDsToDelete: [String]? {
        set {
            subscriptionsOperation.subscriptionIDsToDelete = newValue
        }
        get {
            return subscriptionsOperation.subscriptionIDsToDelete
        }
    }
    
    private(set) var savedSubscriptions: [CKSubscription]?
    
    private(set) var deletedSubscriptionIDs: [String]?
    
    // MARK: - Initialization
    
    init(subscriptionsToSave: [CKSubscription]?, subscriptionIDsToDelete: [String]?, database: CKDatabase = CKContainer.current().publicCloudDatabase) {
        self.subscriptionsOperation = CKModifySubscriptionsOperation(subscriptionsToSave: subscriptionsToSave, subscriptionIDsToDelete: subscriptionIDsToDelete)
        super.init(database: database)
    }

    // MARK: - Execution
    
    override func execute() {
        let subscriptionsOperation = CKModifySubscriptionsOperation(subscriptionsToSave: subscriptionsToSave, subscriptionIDsToDelete: subscriptionIDsToDelete)
        subscriptionsOperation.modifySubscriptionsCompletionBlock = { savedSubscriptions, deletedSubscriptionIDs, error in
            self.deletedSubscriptionIDs = deletedSubscriptionIDs
            self.savedSubscriptions = savedSubscriptions
            self.finish(error)
        }
        database.addOperation(subscriptionsOperation)
    }
}
