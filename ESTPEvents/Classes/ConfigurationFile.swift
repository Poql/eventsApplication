//
//  ConfigurationFile.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 04/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import CloudKit

struct ConfigurationFile: Record, Entity {

    var currentVersion: String? {
        set {
            record["currentVersion"] = newValue
        }
        get {
            return record["currentVersion"] as? String
        }
    }

    var requiredVersion: String? {
        set {
            record["requiredVersion"] = newValue
        }
        get {
            return record["requiredVersion"] as? String
        }
    }

    var tintColor: String? {
        set {
            record["tintColor"] = newValue
        }
        get {
            return record["tintColor"] as? String
        }
    }

    let record: CKRecord

    init(record: CKRecord) {
        self.record = record
    }
}
