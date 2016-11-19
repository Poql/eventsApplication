//
//  PersistentRecord.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 03/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import CoreData
import BNRCoreDataStack

class PersistentRecord: NSManagedObject, CoreDataModelable {
    class var entityName: String {
        return "PersistentRecord"
    }

    @NSManaged var read: Bool
    @NSManaged var metadata: NSData
    @NSManaged var changeTag: String?
    @NSManaged var recordName: String
    @NSManaged var creationDate: NSDate?
    @NSManaged var modificationDate: NSDate?
}
