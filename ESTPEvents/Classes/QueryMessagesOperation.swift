//
//  QueryMessagesOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 23/10/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import CloudKit

class QueryMessagesOperation: QueryOperation, QueryMessagesOperationPrototype {
    var messages: [Message] {
        return fetchedRecords.map { Message(record: $0) }
    }

    init() {
        let limitDate = NSDate().twoMonthsBefore()
        let predicate = NSPredicate(format: "creationDate >= %@", limitDate)
        let query = CKQuery(record: Message.self, predicate: predicate)
        super.init(query: query)
    }
}

