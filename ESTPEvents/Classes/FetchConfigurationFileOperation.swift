//
//  FetchConfigurationFileOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 04/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import CloudKit

class FetchConfigurationFileOperation: QueryOperation, FetchConfigurationFileOperationPrototype {
    var configurationFile: ConfigurationFile? {
        return fetchedRecords.map { ConfigurationFile(record: $0) }.first
    }

    init() {
        let predicate = NSPredicate.alwaysTrue()
        let query = CKQuery(record: ConfigurationFile.self, predicate: predicate)
        super.init(query: query)
    }
}
