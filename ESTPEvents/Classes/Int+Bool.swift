//
//  Int+Bool.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 02/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

extension Int {
    init(_ b: Bool?) {
        self = (b ?? false) ? 1 : 0
    }
}

extension Bool {
    init(_ i: Int?) {
        self = (i ?? 0) == 1
    }
}
