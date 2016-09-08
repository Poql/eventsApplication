//
//  FetchRecordOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 08/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import CloudKit

class FetchRecordOperation: FetchRecordsOperation {
    
    var resultingRecord: Record? {
        guard let record = resultingRecords?.first?.1 else { return nil }
        switch record.recordType {
        case Event.name:
            return Event(record: record)
        default:
            return nil
        }
    }
    
    init(recordName: String) {
        let recordID = CKRecordID(recordName: recordName)
        super.init(recordIDs: [recordID])
    }
}
