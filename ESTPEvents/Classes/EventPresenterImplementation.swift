//
//  EventPresenterImplementation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 02/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations
import BNRCoreDataStack

class EventPresenterImplementation<R: EventRepository, PR: PersistencyRepository>: EventPresenter {
    private let eventRepository: R

    private let persistencyRepository: PR
    
    private let operationQueue = OperationQueue()

    private(set) var events: [Event] = []
    
    private var resultsController: FetchedResultsController<PersistentEvent>?

    weak var client: EventPresenterClient?
    
    init(repository: R, persistencyRepository: PR) {
        self.eventRepository = repository
        self.persistencyRepository = persistencyRepository
        loadResultsController()
    }

    // MARK: - Private

    private func loadResultsController() {
        let operation = ReturnCoreDataStackOperation()
        operation.addCompletionBlockOnMainQueue {
            guard let mainContext = operation.stack?.mainQueueContext else { return }
            self.setResultsController(with: mainContext)
        }
        operationQueue.addOperation(operation)
    }
    
    private func setResultsController(with context: NSManagedObjectContext) {
        let request = NSFetchRequest(entity: PersistentEvent.self)
        request.sortDescriptors = [NSSortDescriptor(key: "eventDescription", ascending: true)]
        resultsController = FetchedResultsController<PersistentEvent>(fetchRequest: request, managedObjectContext: context)
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
