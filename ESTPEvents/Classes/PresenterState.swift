//
//  PresenterState.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 04/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

enum PresenterState<E: ErrorType> {
    case empty
    case loading
    case value
    case error(E)
}
