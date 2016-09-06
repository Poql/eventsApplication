//
//  RecordMapper.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 04/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import CloudKit
import BNRCoreDataStack

struct RecordMapper {
    
    // MARK: - Private
    
    private static func insertPersistentRecord<R: Record, PR: PersistentRecord where PR: CoreDataModelable>(from record: R, inContext context: NSManagedObjectContext) -> PR {
        let persistentRecord = PR(managedObjectContext: context)
        return persistentRecord
    }
}
