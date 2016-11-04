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
    func persistEventsOperation() -> StackedPersistEventsOperation {
        return StackedPersistEventsOperation()
    }
    
    func deleteMessagesOperation(limitDate limitDate: NSDate) -> StackedDeleteMessagesOperation {
        return StackedDeleteMessagesOperation(limitDate: limitDate)
    }

    func deleteEventsOperation(limitDate limitDate: NSDate) -> StackedDeleteEventsOperation {
        return StackedDeleteEventsOperation(limitDate: limitDate)
    }

    func persistMessagesOperation() -> StackedPersistMessagesOperation {
        return StackedPersistMessagesOperation()
    }
}
