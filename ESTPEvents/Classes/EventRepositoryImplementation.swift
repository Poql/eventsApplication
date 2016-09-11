//
//  EventRepositoryImplementation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 03/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

class EventRepositoryImplementation: EventRepository {
    func queryEventsOperation() -> QueryEventsOperation {
        return QueryEventsOperation()
    }

    func modifyEventOperation(event event: Event) -> ModifyEventOperation {
        return ModifyEventOperation(event: event)
    }
}
