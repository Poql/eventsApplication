//
//  QueryOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 02/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations
import CloudKit

class QueryOperation: CloudOperation {
    private var queryOperation: CKQueryOperation
    
    private(set) var fetchedRecords: [CKRecord] = []

    var query: CKQuery? {
        get {
            return queryOperation.query
        }
        set {
            queryOperation.query = newValue
        }
    }
    
    // MARK: - Init
    
    init(query: CKQuery?, database: CKDatabase = CKContainer.defaultContainer().publicCloudDatabase) {
        self.queryOperation = CKQueryOperation()
        super.init(database: database)
        self.query = query
    }
    
    // MARK: - Execution
    
    override func execute() {
        execute(queryOperation)
    }
    
    private func execute(queryOperation: CKQueryOperation) {
        queryOperation.recordFetchedBlock = { record in
            self.fetchedRecords.append(record)
        }
        queryOperation.queryCompletionBlock = { cursor, error in
            if let cursor = cursor {
                self.execute(CKQueryOperation(cursor: cursor))
                return
            }
            self.finish(error)
        }
        database.addOperation(queryOperation)
    }
}
