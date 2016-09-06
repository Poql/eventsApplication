//
//  PersistencyRepositoryImplementation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 04/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations

class PersistencyRepositoryImplementation: PersistencyRepository {
    func persistEventsOperation() -> PersistEventsOperation {
        return PersistEventsOperation()
    }
}
