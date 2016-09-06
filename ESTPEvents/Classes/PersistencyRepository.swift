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
    var completionHandler: (([Event]) -> Void)? { get set }
}

protocol PersistencyRepository {
    associatedtype PersistEventsOperation: Operation, PersistEventsOperationPrototype
    
    func persistEventsOperation() -> PersistEventsOperation
}
