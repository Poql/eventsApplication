//
//  PersistEventsOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 04/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import BNRCoreDataStack
import Operations

class StackedPersistEventsOperation: DataStackProviderOperation, PersistEventsOperationPrototype {
    private let persistEventsOperation = PersistRecordsOperation<PersistentEvent, Event, EventRecordMapper>()
    var events: [Event] {
        set {
            persistEventsOperation.records = newValue
        }
        get {
            return persistEventsOperation.records
        }
    }

    override init() {
        super.init()
        addDataStackOperation(persistEventsOperation)
    }
}
