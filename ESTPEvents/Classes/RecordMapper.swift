//
//  RecordMapper.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 04/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import CloudKit
import BNRCoreDataStack

class Mapper {

    static func shouldUpdatePersistentRecord<R: Record, PR: PersistentRecord where PR: CoreDataModelable>(persistentRecord: PR, with record: R) -> Bool {
        let eventModificationDate = record.record.modificationDate ?? NSDate.distantFuture()
        let persistentEventModificationDate = persistentRecord.modificationDate ?? NSDate.distantPast()
        let persistentDateIsOlder = persistentEventModificationDate.compare(eventModificationDate) == .OrderedAscending
        let changeTagDidChange = persistentRecord.changeTag ?? "0" != record.record.recordChangeTag ?? "1"
        return persistentDateIsOlder && changeTagDidChange
    }
    
    static func insertPersistentRecord<R: Record, PR: PersistentRecord where PR: CoreDataModelable>(from record: R, inContext context: NSManagedObjectContext) -> PR {
        let persistentRecord = PR(managedObjectContext: context)
        return persistentRecord
    }
    
    static func updatePersistentRecord<R: Record, PR: PersistentRecord where PR: CoreDataModelable>(persistentRecord: PR, with record: R) {
        let archivedData = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: archivedData)
        archiver.requiresSecureCoding = true
        record.record.encodeSystemFieldsWithCoder(archiver)
        archiver.finishEncoding()
        persistentRecord.metadata = archivedData
        persistentRecord.recordName = record.record.recordID.recordName
        persistentRecord.modificationDate = record.record.modificationDate
        persistentRecord.creationDate = record.record.creationDate
        persistentRecord.changeTag = record.record.recordChangeTag
    }
    
    static func record<R: Record, PR: PersistentRecord>(from persistentRecord: PR) -> R {
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: persistentRecord.metadata)
        unarchiver.requiresSecureCoding = true
        return R(record: CKRecord(coder: unarchiver)!)
    }
}
