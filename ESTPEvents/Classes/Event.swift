//
//  Event.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 02/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import CloudKit

struct Event: Entity, Record {

    var author: String? {
        get {
            return record["author"] as? String
        }
        set {
            record["author"] = newValue
        }
    }
    
    var description: String? {
        get {
            return record["description"] as? String
        }
        set {
            record["description"] = newValue
        }
    }
    
    var type: String? {
        get {
            return record["type"] as? String
        }
        set {
            record["type"] = newValue
        }
    }
    
    var color: String? {
        get {
            return record["color"] as? String
        }
        set {
            record["color"] = newValue
        }
    }
    
    var eventDate: NSDate? {
        get {
            return record["eventDate"] as? NSDate
        }
        set {
            record["eventDate"] = newValue
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
    
    var cancelled: Bool {
        get {
            return Bool(record["cancelled"] as? Int)
        }
        set {
            self.record["cancelled"] = Int(newValue)
        }
    }
    
    let record: CKRecord

    init(record: CKRecord) {
        self.record = record
    }
}
