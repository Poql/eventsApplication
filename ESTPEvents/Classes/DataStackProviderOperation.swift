//
//  DataStackProviderOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 14/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations
import BNRCoreDataStack

class DataStackProviderOperation: GroupOperation {
    static let loadDataStackOperation = LoadCoreDataStackOperation()

    private lazy var loaderBlock: BlockOperation = {
        return BlockOperation {
            let loadDataStackOperation = self.dynamicType.loadDataStackOperation
            if !loadDataStackOperation.finished {
                self.addOperation(loadDataStackOperation)
            }
        }
    }()

    private var dataStackOperations: [DataStackOperation] {
        return operations.flatMap { $0 as? DataStackOperation }
    }

    init() {
        super.init(operations: [])
        addOperation(loaderBlock)
        addCondition(MutuallyExclusive<DataStackProviderOperation>())
    }

    func addDataStackOperation<O: Operation where O: DataStackOperation>(operation: O) {
        (operation as Operation).addDependency(loaderBlock)
        addOperation(operation)
    }

    override func operationQueue(queue: OperationQueue, willFinishOperation operation: NSOperation, withErrors errors: [ErrorType]) {
        guard operation == loaderBlock else { return }
        dataStackOperations.forEach { $0.injectDataStack(self.dynamicType.loadDataStackOperation.stack) }
    }
}