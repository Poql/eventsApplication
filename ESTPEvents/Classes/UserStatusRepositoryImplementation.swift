//
//  UserStatusRepositoryImplementation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 13/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

class UserStatusRepositoryImplementation: UserStatusRepository {
    func fetchUserStatusOperation() -> FetchUserStatusOperation {
        return FetchUserStatusOperation()
    }
}
