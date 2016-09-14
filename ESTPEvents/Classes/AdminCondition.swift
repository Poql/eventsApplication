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
        let authProvider = AuthenticationProviderOperation()
        let operation = FetchAdminOperation()
        authProvider.addAuthenticatedOperation(operation)
        operation.addWillFinishBlock { self.admin = operation.resultingAdmin }
        addDependency(authProvider)
    }

    override func evaluate(operation: Operation, completion: CompletionBlockType) {
        completion((admin?.accepted ?? false) ? .Satisfied : .Failed(OperationError.adminNotAccepted))
    }
}
