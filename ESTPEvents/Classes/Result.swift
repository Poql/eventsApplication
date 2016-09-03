//
//  Result.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 02/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

enum Result<V, E> {
    case value(V)
    case error(E)
}
