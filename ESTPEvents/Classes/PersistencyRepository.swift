//
//  PersistencyRepository.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 04/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations

protocol PersistEventsOperationPrototype: class {
    var events: [Event] { get set }
}

protocol DeleteEventsOperationPrototype: class {
    var limitDate: NSDate { get set }
}

protocol PersistMessagesOperationPrototype: class {
    var messages: [Message] { get set }
}

protocol DeleteMessagesOperationPrototype: class {
    var limitDate: NSDate { get set }
}

protocol MarkAsReadLocalMessagesOperationPrototype: class {}
protocol MarkAsReadLocalEventsOperationPrototype: class {}

protocol PersistencyRepository {
    associatedtype PersistEventsOperation: Operation, PersistEventsOperationPrototype
    associatedtype DeleteEventsOperation: Operation, DeleteEventsOperationPrototype
    associatedtype PersistMessagesOperation: Operation, PersistMessagesOperationPrototype
    associatedtype DeleteMessagesOperation: Operation, DeleteMessagesOperationPrototype
    associatedtype MarkAsReadLocalMessagesOperation: Operation, MarkAsReadLocalMessagesOperationPrototype
    associatedtype MarkAsReadLocalEventsOperation: Operation, MarkAsReadLocalEventsOperationPrototype
    
    func persistEventsOperation() -> PersistEventsOperation
    func deleteEventsOperation(limitDate limitDate: NSDate) -> DeleteEventsOperation
    func persistMessagesOperation() -> PersistMessagesOperation
    func deleteMessagesOperation(limitDate limitDate: NSDate) -> DeleteMessagesOperation
    func markAsReadLocalMessagesOperation() -> MarkAsReadLocalMessagesOperation
    func markAsReadLocalEventsOperation() -> MarkAsReadLocalEventsOperation
}
