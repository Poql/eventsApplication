//
//  ContextOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 03/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations
import BNRCoreDataStack

protocol ManagedObjectContextOperation: class {
    var context: NSManagedObjectContext? { get set }
}

class ManagedObjectContextCondition: Condition {
    private let coreDataStackOperation = ReturnCoreDataStackOperation()
    
    override init() {
        super.init()
        addDependency(coreDataStackOperation)
    }

    override func evaluate(operation: Operation, completion: OperationConditionResult -> Void) {
        guard let contexOperation = operation as? ManagedObjectContextOperation else {
            completion(.Satisfied)
            return
        }
        if let stack = coreDataStackOperation.stack {
            contexOperation.context = stack.newChildContext()
            completion(.Satisfied)
            return
        }
        completion(.Failed(OperationError.noContext))
    }
}
