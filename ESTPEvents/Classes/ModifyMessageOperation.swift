//
//  ModifyMessageOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 04/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import CloudKit

class ModifyMessageOperation: ModifyRecordsOperation, ModifyMessageOperationPrototype {

    var message: Message? {
        set {
            if let message = newValue {
                recordsToSave = [message.record]
                return
            }
            recordsToSave = nil
        }
        get {
            if let record = recordsToSave?.first {
                return Message(record: record)
            }
            return nil
        }
    }

    var resultingMessage: Message? {
        if let record = savedRecords?.first {
            return Message(record: record)
        }
        return nil
    }

    init(message: Message) {
        super.init(recordsToSave: [message.record], recordIDsToDelete: nil, database: CKContainer.current().publicCloudDatabase)
        savePolicy = .AllKeys
        addCondition(AdminCondition())
    }
}

