//
//  MarkAsReadLocalRecordOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 19/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Operations
import BNRCoreDataStack

class MarkAsReadLocalRecordOperationProvider<E: PersistentRecord>: DataStackProviderOperation {
    private let operation = MarkAsReadLocalRecordOperation<E>()
    override init() {
        super.init()
        addDataStackOperation(operation)
    }
}

class MarkAsReadLocalRecordOperation<E: PersistentRecord>: ContextOperation {
    override func execute() {
        performBlock { context in
            let request = NSFetchRequest(entity: E.self)
            let records = try! context.executeFetchRequest(request) as! [E]
            records.forEach { record in
                record.read = true
            }
            self.saveContextAndFinish()
        }
    }
}
