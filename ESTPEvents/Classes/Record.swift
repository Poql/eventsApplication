//
//  Record.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 02/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import CloudKit

protocol Record {
    static var name: String { get }
    var record: CKRecord { get }
    init(record: CKRecord)
}

extension Record {
    static var name: String {
        return String(self)
    }
}

extension Entity where Self: Record {

    var id: String {
        return record.recordID.recordName
    }
    
    var deleted: Bool {
        get {
            return Bool(record["deleted"] as? Int)
        }
        set {
            record["deleted"] = Int(newValue)
        }
    }
    
    var modificationDate: NSDate {
        return record.modificationDate ?? NSDate.distantPast()
    }
    
    init() {
        self.init(record: CKRecord(recordType: Self.name))
    }
}
