//
//  EventRecordMapper.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 23/10/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import BNRCoreDataStack

class EventRecordMapper: Mapper, RecordMapper, PersistentRecordMapper {
    static func getRecord(from persistentRecord: PersistentEvent) -> Event {
        var event: Event = record(from: persistentRecord)
        event.description = persistentRecord.eventDescription
        event.color = persistentRecord.color
        event.eventDate = persistentRecord.eventDate
        event.link = persistentRecord.link
        event.location = persistentRecord.location
        event.notify = persistentRecord.notify
        event.cancelled = persistentRecord.cancelled
        event.type = persistentRecord.type
        event.creator = persistentRecord.creator
        event.title = persistentRecord.title
        event.read = persistentRecord.read
        return event
    }

    // MARK: - RecordMapper

    static func insertPersistentRecord(from record: Event, in context: NSManagedObjectContext) {
        let persistenEvent: PersistentEvent = insertPersistentRecord(from: record, inContext: context)
        update(persistentRecord: persistenEvent, with: record)
    }

    static func update(persistentRecord persistentRecord: PersistentEvent, with record: Event) {
        guard shouldUpdatePersistentRecord(persistentRecord, with: record) else { return }
        updatePersistentRecord(persistentRecord, with: record)
        persistentRecord.eventDescription = record.description ?? ""
        persistentRecord.color = record.color ?? ""
        persistentRecord.eventDate = record.eventDate ?? NSDate.distantPast()
        persistentRecord.link = record.link ?? ""
        persistentRecord.location = record.location
        persistentRecord.notify = record.notify
        persistentRecord.cancelled = record.cancelled
        persistentRecord.type = record.type ?? ""
        persistentRecord.creator = record.creator ?? ""
        persistentRecord.title = record.title ?? ""
    }
}
