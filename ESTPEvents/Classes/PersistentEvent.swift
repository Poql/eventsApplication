//
//  PersistentEvent.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 03/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import CoreData
import BNRCoreDataStack

class PersistentEvent: PersistentRecord {
    override class var entityName: String {
        return "PersistentEvent"
    }

    @NSManaged var eventDescription: String
}
