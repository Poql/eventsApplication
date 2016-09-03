//
//  EventPresenterImplementation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 02/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations

class EventPresenterImplementation<Repository: EventRepository>: EventPresenter {
    private let eventRepository: Repository
    
    private let operationQueue = OperationQueue()

    private(set) var events: [Event] = []

    weak var client: EventPresenterClient?
    
    init(repository: Repository) {
        self.eventRepository = repository
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
