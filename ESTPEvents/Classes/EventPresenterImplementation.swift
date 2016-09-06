//
//  EventPresenterImplementation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 02/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations

class EventPresenterImplementation<R: EventRepository, PR: PersistencyRepository>: EventPresenter {
    private let eventRepository: R

    private let persistencyRepository: PR
    
    private let operationQueue = OperationQueue()

    private(set) var events: [Event] = []

    weak var client: EventPresenterClient?
    
    init(repository: R, persistencyRepository: PR) {
        self.eventRepository = repository
        self.persistencyRepository = persistencyRepository
    }
    
    // MARK: - EventPresenter

    func queryAllEvents() {
        let operation = eventRepository.queryEventsOperation()
        operation.completionHandler = { result in
            switch result {
            case let .error(err):
                print(err)
            case let .value(events):
                self.events = events
                self.client?.presenterDidQueryEvents()
            }
        }
        operationQueue.addOperation(operation)
    }
}
