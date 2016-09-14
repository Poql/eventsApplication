//
//  AdminCondition.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 13/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations
import CloudKit

class AdminCondition: Condition {

    private var admin: Admin?

    override init() {
        super.init()
        addCondition(AuthorizedFor(Capability.Cloud (permissions: [CKApplicationPermissions.UserDiscoverability])))
        let operation = FetchAdminOperation()
        operation.addWillFinishBlock { self.admin = operation.resultingAdmin }
        addDependency(operation)
    }

    override func evaluate(operation: Operation, completion: CompletionBlockType) {
        guard let operation = operation as? AuthenticatedOperation else {
            completion(.Ignored)
            return
        }
        operation.userID = admin?.userReference?.recordID
        completion((admin?.accepted ?? false) ? .Satisfied : .Failed(OperationError.adminNotAccepted))
    }
}
