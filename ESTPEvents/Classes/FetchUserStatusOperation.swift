//
//  FetchUserStatusOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 13/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Operations
import CloudKit

class FetchUserStatusOperation: AuthenticationProviderOperation, FetchUserStatusOperationPrototype {
    private let fetchAdminOperation = FetchAdminOperation()
    var userStatus: UserStatus {
        return UserStatus(admin: fetchAdminOperation.resultingAdmin)
    }
    override init() {
        super.init()
        addAuthenticatedOperation(fetchAdminOperation)
    }
}
