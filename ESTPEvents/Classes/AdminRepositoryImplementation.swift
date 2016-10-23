//
//  AdminRepositoryImplementation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 16/10/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

class AdminRepositoryImplementation: AdminRepository {

    func requestToBecomeAdminOperation() -> RequestToBecomeAdminOperation {
        return RequestToBecomeAdminOperation()
    }
}
