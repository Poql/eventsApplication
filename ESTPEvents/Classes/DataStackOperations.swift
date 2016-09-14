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


class DataStackBlockOperation: Operation, DataStackOperation {
    var dataStack: CoreDataStack?

    var block: (CoreDataStack?) -> Void

    init(mainQueueBlock: (CoreDataStack?) -> Void) {
        self.block = mainQueueBlock
        super.init()
    }

    override func execute() {
        dispatch_async(Queue.Main.queue) {
            self.block(self.dataStack)
            self.finish()
        }
    }
}

class ContextOperation: Operation, DataStackOperation {
    var dataStack: CoreDataStack?

    private(set) var context: NSManagedObjectContext?

    override init() {
        super.init()
        addCondition(DataStackCondition())
    }

    // MARK: - DataStackOperation

    final func injectDataStack(dataStack: CoreDataStack?) {
        self.dataStack = dataStack
        self.context = dataStack?.newChildContext()
    }

    // MARK: - Public

    func performBlock(block: (inContext: NSManagedObjectContext) -> Void) {
        guard let context = context else { finish(); return }
        context.performBlock {
            block(inContext: context)
        }
    }

    func saveContextAndFinish() {
        context?.saveContext { result in
            switch result {
            case let .Failure(err):
                self.finish(err)
            case .Success:
                self.finish()
            }
        }
    }
}
