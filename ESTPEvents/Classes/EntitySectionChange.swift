//
//  EntitySectionChange.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 06/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

enum EntitySectionChange {
    case insert(index: Int)
    case delete(index: Int)
}