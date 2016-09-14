//
//  DeleteEventsOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 07/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Operations
import BNRCoreDataStack

class StackedDeleteEventsOperation: DataStackProviderOperation, DeleteEventsOperationPrototype {
    private let deleteEventsOperation: DeleteEventsOperation
    var limitDate: NSDate {
        set {
            deleteEventsOperation.limitDate = newValue
        }
        get {
            return deleteEventsOperation.limitDate
        }
    }

    init(limitDate: NSDate) {
        deleteEventsOperation = DeleteEventsOperation(limitDate: limitDate)
        super.init()
        addDataStackOperation(deleteEventsOperation)
    }
}

class DeleteEventsOperation: ContextOperation {
    var limitDate: NSDate

    init(limitDate: NSDate) {
        self.limitDate = limitDate
    }

    override func execute() {
        performBlock { context in
            self.deleteEvents(beforeDate: self.limitDate, inContext: context)
            self.saveContextAndFinish()
        }
    }

    // MARK: - Private

    private func deleteEvents(beforeDate date: NSDate, inContext context: NSManagedObjectContext) {
        let request = NSFetchRequest(entity: PersistentEvent.self)
        request.predicate = NSPredicate(format: "eventDate <= %@", date)
        let events = try! context.executeFetchRequest(request) as! [PersistentEvent]
        for event in events {
            context.deleteObject(event)
        }
    }
}
