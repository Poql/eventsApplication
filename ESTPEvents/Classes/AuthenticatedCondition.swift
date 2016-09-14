//
//  AuthentifiedCondition.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 13/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations
import CloudKit

class AuthenticatedCondition: Condition {
    override func evaluate(operation: Operation, completion: CompletionBlockType) {
        guard let operation = operation as? AuthenticatedOperation else {
            completion(.Ignored)
            return
        }
        completion(operation.userID == nil ? .Failed(OperationError.notAuthenticated) : .Satisfied)
    }
}
