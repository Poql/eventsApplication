//
//  FetchUserStatusOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 13/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Operations
import CloudKit

class FetchUserStatusOperation: FetchAdminOperation, FetchUserStatusOperationPrototype {
    var userStatus: UserStatus {
        return UserStatus(admin: resultingAdmin)
    }
}
