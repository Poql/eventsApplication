//
//  Message.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 23/10/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import CloudKit

struct Message: Record, Entity {

    var author: String? {
        set {
            record["author"] = newValue
        }
        get {
            return record["author"] as? String
        }
    }

    var notify: Bool {
        get {
            return Bool(record["notify"] as? Int)
        }
        set {
            record["notify"] = Int(newValue)
        }
    }

    var content: String? {
        set {
            record["content"] = newValue
        }
        get {
            return record["content"] as? String
        }
    }

    var read = false

    let record: CKRecord

    init(record: CKRecord) {
        self.record = record
    }
}
