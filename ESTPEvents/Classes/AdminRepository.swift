//
//  AdminRepository.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 16/10/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations

protocol RequestToBecomeAdminOperationPrototype {
    var adminAlreadyCreated: Bool { get }
}

protocol AdminRepository {
    associatedtype RequestToBecomeAdminOperation: Operation, RequestToBecomeAdminOperationPrototype

    func requestToBecomeAdminOperation() -> RequestToBecomeAdminOperation
}
