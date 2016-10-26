//
//  EventRecordMapper.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 23/10/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import BNRCoreDataStack

class EventRecordMapper: Mapper, RecordMapper {
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
