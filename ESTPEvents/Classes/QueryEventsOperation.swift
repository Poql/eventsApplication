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

class QueryEventsOperation: QueryOperation, QueryEventsOperationPrototype {
    var events: [Event] {
        return fetchedRecords.map {Event(record: $0)}
    }

    init() {
        let predicate = NSPredicate(format: "TRUEPREDICATE")
        let query = CKQuery(record: Event.self, predicate: predicate)
        super.init(query: query)
    }
}

