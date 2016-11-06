//
//  UserStatusRepository.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 13/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations

enum UserStatus: Int {
    case follower = 1
    case admin
    init(admin: Admin?) {
        self = (admin?.accepted ?? false) ? .admin : .follower
    }
}

protocol FetchUserStatusOperationPrototype {
    var userStatus: UserStatus { get }
}

protocol FetchConfigurationFileOperationPrototype {
    var configurationFile: ConfigurationFile? { get }
}

protocol UserStatusRepository {
    associatedtype FetchUserStatusOperation: Operation, FetchUserStatusOperationPrototype
    associatedtype FetchConfigurationFileOperation: Operation, FetchConfigurationFileOperationPrototype

    func fetchUserStatusOperation() -> FetchUserStatusOperation
    func fetchConfigurationFileOperation() -> FetchConfigurationFileOperation
}
