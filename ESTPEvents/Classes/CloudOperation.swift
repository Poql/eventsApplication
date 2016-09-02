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
    
    init(database: CKDatabase) {
        self.database = database
        super.init()
    }
}
