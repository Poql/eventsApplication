//
//  FetchRecordsOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 08/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Operations
import CloudKit

class FetchRecordsOperation: CloudOperation {
    private let fetchRecordsOperation: CKFetchRecordsOperation
    
    var recordIDs: [CKRecordID]? {
        set {
            fetchRecordsOperation.recordIDs = recordIDs
        }
        get {
            return fetchRecordsOperation.recordIDs
        }
    }
    
    private(set) var resultingRecords: [CKRecordID : CKRecord]?
    
    init(recordIDs: [CKRecordID], database: CKDatabase = CKContainer.current().publicCloudDatabase) {
        self.fetchRecordsOperation = CKFetchRecordsOperation(recordIDs: recordIDs)
        super.init(database: database)
    }
    
    override func execute() {
        fetchRecordsOperation.fetchRecordsCompletionBlock = { recordsDictionary, error in
            self.resultingRecords = recordsDictionary
            self.finish(error)
        }
        database.addOperation(fetchRecordsOperation)
    }
}
