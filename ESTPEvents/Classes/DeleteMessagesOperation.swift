//
//  DeleteMessagesOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 04/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Operations
import BNRCoreDataStack

class StackedDeleteMessagesOperation: DataStackProviderOperation, DeleteMessagesOperationPrototype {
    private let deleteMessagesOperation: DeleteMessagesOperation
    var limitDate: NSDate {
        set {
            deleteMessagesOperation.limitDate = newValue
        }
        get {
            return deleteMessagesOperation.limitDate
        }
    }

    init(limitDate: NSDate) {
        deleteMessagesOperation = DeleteMessagesOperation(limitDate: limitDate)
        super.init()
        addDataStackOperation(deleteMessagesOperation)
    }
}

class DeleteMessagesOperation: ContextOperation {
    var limitDate: NSDate

    init(limitDate: NSDate) {
        self.limitDate = limitDate
    }

    override func execute() {
        performBlock { context in
            self.deleteMessages(beforeDate: self.limitDate, inContext: context)
            self.saveContextAndFinish()
        }
    }

    // MARK: - Private

    private func deleteMessages(beforeDate date: NSDate, inContext context: NSManagedObjectContext) {
        let request = NSFetchRequest(entity: PersistentMessage.self)
        request.predicate = NSPredicate(format: "creationDate <= %@", date)
        let events = try! context.executeFetchRequest(request) as! [PersistentMessage]
        for event in events {
            context.deleteObject(event)
        }
    }
}
