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

    private var userID: CKRecordID?

    override init() {
        super.init()
        let operation = FetchUserOperation(container: CKContainer(identifier: "iCloud.com.gzanella.ESTPEvents"))
        operation.addWillFinishBlock { self.userID = operation.userID }
        addDependency(operation)
    }

    override func evaluate(operation: Operation, completion: CompletionBlockType) {
        guard let operation = operation as? AuthenticatedOperation else {
            completion(.Ignored)
            return
        }
        operation.userID = userID
        completion(userID == nil ? .Failed(OperationError.notAuthenticated) : .Satisfied)
    }
}
