//
//  ReturnCoreDataStackOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 06/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations
import BNRCoreDataStack

class ReturnCoreDataStackOperation: GroupOperation {
    static let loadDataStackOperation = LoadCoreDataStackOperation()
    
    var stack: CoreDataStack? {
        return self.dynamicType.loadDataStackOperation.stack
    }
    
    private lazy var getCoreDataStackOperation: BlockOperation = {
        let operation = BlockOperation {
            guard self.stack == nil else { return }
            let loadDataStackOperation = self.dynamicType.loadDataStackOperation
            if !loadDataStackOperation.executing && !loadDataStackOperation.finished {
                self.addOperation(loadDataStackOperation)
            } else if loadDataStackOperation.executing {
                let waitingOperation = BlockOperation()
                waitingOperation.addDependency(loadDataStackOperation)
                self.addOperation(waitingOperation)
            }
        }
        return operation
    }()
    
    init() {
        super.init(operations: [])
        addOperation(getCoreDataStackOperation)
        userIntent = .Initiated
    }
}
