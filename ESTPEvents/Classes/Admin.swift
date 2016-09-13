//
//  Admin.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 13/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import CloudKit

struct Admin: Record, Entity {

    var userReference: CKReference? {
        set {
            record["user"] = newValue
        }
        get {
            return record["user"] as? CKReference
        }
    }

    var accepted: Bool {
        set {
            record["accepted"] = Int(newValue)
        }
        get {
            return Bool(record["accepted"] as? Int)
        }
    }

    let record: CKRecord

    init(record: CKRecord) {
        self.record = record
    }
}
