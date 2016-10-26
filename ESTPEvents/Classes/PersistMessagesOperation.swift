//
//  PersistMessagesOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 26/10/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import BNRCoreDataStack
import Operations

class StackedPersistMessagesOperation: DataStackProviderOperation, PersistMessagesOperationPrototype {
    private let persistOperation = PersistRecordsOperation<PersistentMessage, Message, MessageRecordMapper>()
    var messages: [Message] {
        set {
            persistOperation.records = newValue
        }
        get {
            return persistOperation.records
        }
    }

    override init() {
        super.init()
        addDataStackOperation(persistOperation)
    }
}
