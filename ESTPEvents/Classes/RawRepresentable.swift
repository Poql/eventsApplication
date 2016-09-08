//
//  Countable.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 08/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

extension RawRepresentable where RawValue == Int {
    static var count: Int {
        var i = 0
        while let _ = self.init(rawValue: i) {
            i += 1
        }
        return i
    }
}
