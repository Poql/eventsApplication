//
//  EntityChange.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 04/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

enum EntityChange {
    case insert(indexPath: NSIndexPath)
    case delete(indexPath: NSIndexPath)
    case move(fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath)
    case update(indexPath: NSIndexPath)
}
