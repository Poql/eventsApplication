//
//  MessageRecordMapper.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 23/10/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import BNRCoreDataStack

class MessageRecordMapper: Mapper, RecordMapper, PersistentRecordMapper {
    static func getRecord(from persistentRecord: PersistentMessage) -> Message {
        var message: Message = record(from: persistentRecord)
        message.author = persistentRecord.author
        message.content = persistentRecord.content
        message.read = persistentRecord.read
        message.isAlert = persistentRecord.isAlert
        return message
    }

    // MARK: - RecordMapper

    static func insertPersistentRecord(from record: Message, in context: NSManagedObjectContext) {
        let persistenMessage: PersistentMessage = insertPersistentRecord(from: record, inContext: context)
        update(persistentRecord: persistenMessage, with: record)
    }

    static func update(persistentRecord persistentRecord: PersistentMessage, with record: Message) {
        guard shouldUpdatePersistentRecord(persistentRecord, with: record) else { return }
        updatePersistentRecord(persistentRecord, with: record)
        persistentRecord.author = record.author ?? ""
        persistentRecord.content = record.content ?? ""
        persistentRecord.isAlert = record.isAlert
    }

}
