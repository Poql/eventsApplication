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

    var creator: String? {
        get {
            return record["creator"] as? String
        }
        set {
            record["creator"] = newValue
        }
    }
    
    var title: String? {
        get {
            return record["title"] as? String
        }
        set {
            record["title"] = newValue
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
    
    var link: String? {
        get {
            return record["link"] as? String
        }
        set {
            record["link"] = newValue
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
    
    var location: CLLocation? {
        get {
            return record["location"] as? CLLocation
        }
        set {
            self.record["location"] = newValue
        }
    }
    
    let record: CKRecord

    init(record: CKRecord) {
        self.record = record
    }
    
    init() {
        self.init(record: CKRecord(recordType: self.dynamicType.name))
    }
}
