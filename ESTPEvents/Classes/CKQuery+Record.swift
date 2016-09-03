//
//  CKQuery+Record.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 02/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import CloudKit

extension CKQuery {
    convenience init(record: Record.Type, predicate: NSPredicate) {
        self.init(recordType: record.name, predicate: predicate)
    }
}
