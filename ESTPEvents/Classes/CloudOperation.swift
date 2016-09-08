//
//  CloudOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 02/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations
import CloudKit

class CloudOperation: Operation {
    let database: CKDatabase
    
    override var name: String? {
        get {
            return String(self.dynamicType)
        }
        set {
            self.name = newValue
        }
    }
    
    init(database: CKDatabase) {
        self.database = database
        super.init()
    }
}
