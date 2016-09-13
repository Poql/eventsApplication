//
//  EventRepository.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 02/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations

protocol QueryEventsOperationPrototype: class {
    var events: [Event] { get }
}

protocol ModifyEventOperationPrototype {
    var event: Event? { get set }
    var resultingEvent: Event? { get }
}

protocol EventRepository {
    associatedtype QueryEventsOperation: Operation, QueryEventsOperationPrototype
    associatedtype ModifyEventOperation: Operation, ModifyEventOperationPrototype
    
    func queryEventsOperation() -> QueryEventsOperation

    func modifyEventOperation(event event: Event) -> ModifyEventOperation
}
