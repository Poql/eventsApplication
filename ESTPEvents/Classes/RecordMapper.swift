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

    static func shouldUpdatePersistentRecord<R: Record, PR: PersistentRecord where PR: CoreDataModelable>(persistentRecord: PR, with record: R) -> Bool {
        let eventModificationDate = record.record.modificationDate ?? NSDate.distantFuture()
        let persistentEventModificationDate = persistentRecord.modificationDate ?? NSDate.distantPast()
        let persistentDateIsOlder = persistentEventModificationDate.compare(eventModificationDate) == .OrderedDescending
        let changeTagDidChange = persistentRecord.changeTag ?? "0" == record.record.recordChangeTag ?? "1"
        return persistentDateIsOlder && changeTagDidChange
    }
    
    static func getEvent(from persistentEvent: PersistentEvent) -> Event {
        var event: Event = record(from: persistentEvent)
        event.description = persistentEvent.eventDescription
        event.color = persistentEvent.color
        event.eventDate = persistentEvent.eventDate
        event.link = persistentEvent.link
        event.location = persistentEvent.location
        event.notify = persistentEvent.notify
        event.cancelled = persistentEvent.cancelled
        event.type = persistentEvent.type
        event.creator = persistentEvent.creator
        event.title = persistentEvent.title
        return event
    }
    
    static func insertPersistentEvent(from event: Event, inContext context: NSManagedObjectContext) -> PersistentEvent {
        let persistenEvent: PersistentEvent = insertPersistentRecord(from: event, inContext: context)
        updatePersistentEvent(persistenEvent, with: event)
        return persistenEvent
    }
    
    static func updatePersistentEvent(persistentEvent: PersistentEvent, with event: Event) {
        guard shouldUpdatePersistentRecord(persistentEvent, with: event) else { return }
        updatePersistentRecord(persistentEvent, with: event)
        persistentEvent.eventDescription = event.description ?? ""
        persistentEvent.color = event.color ?? ""
        persistentEvent.eventDate = event.eventDate ?? NSDate.distantPast()
        persistentEvent.link = event.link ?? ""
        persistentEvent.location = event.location
        persistentEvent.notify = event.notify
        persistentEvent.cancelled = event.cancelled
        persistentEvent.type = event.type ?? ""
        persistentEvent.creator = event.creator ?? ""
        persistentEvent.title = event.title ?? ""
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
