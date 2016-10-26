//
//  MessageRecordMapper.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 23/10/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import BNRCoreDataStack

class MessageRecordMapper: Mapper, RecordMapper {
    static func getMessage(from persistentMessage: PersistentMessage) -> Message {
        var message: Message = record(from: persistentMessage)
        message.author = persistentMessage.author
        message.content = persistentMessage.content
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
    }

}
