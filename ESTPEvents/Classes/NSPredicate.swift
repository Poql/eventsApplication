//
//  NSPredicate.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 08/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

extension NSPredicate {
    static func alwaysTrue() -> NSPredicate {
        return NSPredicate(format: "TRUEPREDICATE")
    }
}
