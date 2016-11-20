//
//  PersistentMessage.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 23/10/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import BNRCoreDataStack

class PersistentMessage: PersistentRecord {
    override class var entityName: String {
        return "PersistentMessage"
    }

    @NSManaged var isAlert: Bool
    @NSManaged var content: String
    @NSManaged var author: String
}
