//
//  ModifyEventOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 10/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import CloudKit

class ModifyEventOperation: ModifyRecordsOperation {
    var event: Event? {
        set {
            if let event = newValue {
                recordsToSave = [event.record]
                return
            }
            recordsToSave = nil
        }
        get {
            if let record = recordsToSave?.first {
                return Event(record: record)
            }
            return nil
        }
    }

    var resultingEvent: Event? {
        if let record = savedRecords?.first {
            return Event(record: record)
        }
        return nil
    }

    init(event: Event) {
        super.init(recordsToSave: [event.record], recordIDsToDelete: nil, database: CKContainer.defaultContainer().publicCloudDatabase)
        savePolicy = .AllKeys
    }
}
