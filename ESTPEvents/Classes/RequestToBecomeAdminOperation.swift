//
//  RequestToBecomeAdminOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 16/10/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import CloudKit
import Operations

class RequestToBecomeAdminOperation: AuthenticationProviderOperation, RequestToBecomeAdminOperationPrototype {
    private let fetchAdminOperation = FetchAdminOperation()
    private let createAdminOperation = CreateAdminOperation()

    private(set) var adminAlreadyCreated = false

    override init() {
        super.init()
        let capability = Capability.Cloud (permissions: [CKApplicationPermissions.UserDiscoverability], containerId: CKContainer.currentID)
        addCondition(AuthorizedFor(capability))
        addAuthenticatedOperation(createAdminOperation)
        addAuthenticatedOperation(fetchAdminOperation)
        fetchAdminOperation.addWillFinishBlock {
            if self.fetchAdminOperation.resultingAdmin != nil {
                self.createAdminOperation.cancel()
                self.adminAlreadyCreated = true
            }
        }
        createAdminOperation.addDependency(fetchAdminOperation)
    }
}
