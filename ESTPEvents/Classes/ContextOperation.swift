//
//  ContextOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 03/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations
import BNRCoreDataStack

protocol ManagedObjectContextOperation: class {
    var context: NSManagedObjectContext? { get set }
}
