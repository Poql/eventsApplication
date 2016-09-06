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

struct RecordMapper {
    
    static func getEvent(from persistentEvent: PersistentEvent) -> Event {
        var event: Event = record(from: persistentEvent)
        event.description = persistentEvent.eventDescription
        return event
    }
    
    static func insertPersistentEvent(from event: Event, inContext context: NSManagedObjectContext) -> PersistentEvent {
        let persistenEvent: PersistentEvent = insertPersistentRecord(from: event, inContext: context)
        updatePersistentEvent(persistenEvent, with: event)
        return persistenEvent
    }
    
    // MARK: - Private
    
    private static func insertPersistentRecord<R: Record, PR: PersistentRecord where PR: CoreDataModelable>(from record: R, inContext context: NSManagedObjectContext) -> PR {
        let persistentRecord = PR(managedObjectContext: context)
        return persistentRecord
    }
    
    private static func updatePersistentRecord<R: Record, PR: PersistentRecord where PR: CoreDataModelable>(persistentRecord: PR, with record: R) {
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
    
    private static func record<R: Record, PR: PersistentRecord>(from persistentRecord: PR) -> R {
        let unarchiver = NSKeyedUnarchiver(forReadingWithData: persistentRecord.metadata)
        unarchiver.requiresSecureCoding = true
        return R(record: CKRecord(coder: unarchiver)!)
    }
}
