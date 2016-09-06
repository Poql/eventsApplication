//
//  NSFetchRequest+CoreDataModelable.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 04/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import BNRCoreDataStack

extension NSFetchRequest {
    convenience init<T: PersistentRecord>(entity: T.Type) {
        self.init(entityName: entity.entityName)
    }
}
