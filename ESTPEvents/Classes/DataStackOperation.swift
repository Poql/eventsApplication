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

protocol DataStackOperation: class {
    var dataStack: CoreDataStack? { get set }
    func injectDataStack(dataStack: CoreDataStack?)
}

extension DataStackOperation {
    func injectDataStack(dataStack: CoreDataStack?) {
        self.dataStack = dataStack
    }
}

class DataStackCondition: Condition {
    override func evaluate(operation: Operation, completion: OperationConditionResult -> Void) {
        guard let dataStackOperation = operation as? DataStackOperation else {
            completion(.Ignored)
            return
        }
        completion(dataStackOperation.dataStack == nil ? .Failed(OperationError.noContext) : .Satisfied)
    }
}
