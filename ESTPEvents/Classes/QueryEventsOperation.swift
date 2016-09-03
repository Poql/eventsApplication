//
//  QueryEventsOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 02/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations
import CloudKit

class QueryEventsOperation: QueryOperation {
    var events: [Event] {
        return fetchedRecords.map {Event(record: $0)}
    }
    
    var completionHandler: ((result: Result<[Event], ApplicationError>) -> Void)?

    init() {
        let predicate = NSPredicate(format: "TRUEPREDICATE")
        let query = CKQuery(record: Event.self, predicate: predicate)
        super.init(query: query)
        addCompletionHandler()
    }
    
    private func addCompletionHandler() {
        addCompletionBlockOnMainQueue {
            let errors = self.errors
            let result: Result<[Event], ApplicationError> = errors.isEmpty ? .value(self.events) : .error(.generic)
            self.completionHandler?(result: result)
        }
    }
}

