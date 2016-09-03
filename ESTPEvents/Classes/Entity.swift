//
//  Entity.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 02/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import CloudKit

protocol Entity: Hashable {
    var id: String { get }
    var deleted: Bool { get set }
    var modificationDate: NSDate { get }
}

extension Entity {
    var hashValue: Int {
        return id.hashValue
    }
}

func ==<T: Entity>(lhs: T, rhs: T) -> Bool {
    return lhs.id == rhs.id
}
