//
//  ModifyRecordsOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 10/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import CloudKit
import Operations

class ModifyRecordsOperation: CloudOperation {
    private let operation: CKModifyRecordsOperation
    
    private(set) var savedRecords: [CKRecord]?

    private(set) var deletedRecordIDs: [CKRecordID]?

    var recordsToSave: [CKRecord]? {
        set {
            operation.recordsToSave = newValue
        }
        get {
            return operation.recordsToSave
        }
    }
    
    var savePolicy: CKRecordSavePolicy {
        set {
            operation.savePolicy = newValue
        }
        get {
            return operation.savePolicy
        }
    }

    // MARK: - Initialization

    init(recordsToSave: [CKRecord]?, recordIDsToDelete: [CKRecordID]?, database: CKDatabase) {
        self.operation = CKModifyRecordsOperation(recordsToSave: recordsToSave, recordIDsToDelete: recordIDsToDelete)
        super.init(database: database)
    }

    // MARK: - Execution

    override func execute() {
        operation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
            self.savedRecords = savedRecords
            self.deletedRecordIDs = deletedRecordIDs
            self.finish(error)
        }
        database.addOperation(operation)
    }
}