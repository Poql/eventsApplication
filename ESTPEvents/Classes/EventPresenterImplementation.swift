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
            self.queryPersistedEvents()
        }
        operationQueue.addOperation(operation)
    }
    
    private func setResultsController(with context: NSManagedObjectContext) {
        let request = NSFetchRequest(entity: PersistentEvent.self)
        request.sortDescriptors = [NSSortDescriptor(key: "eventDescription", ascending: true)]
        resultsController = FetchedResultsController<PersistentEvent>(fetchRequest: request, managedObjectContext: context)
    }

    private func queryRemoteEvents() {
        let operation = eventRepository.queryEventsOperation()
        let persistOperation = persistencyRepository.persistEventsOperation()
        (persistOperation as Operation).addDependency(operation)
        operation.completionHandler = { result in
            switch result {
            case .error:
                self.client?.presenterDidChangeState(.error(ApplicationError.generic))
            case let .value(events):
                persistOperation.events = events
            }
        }
        let group = GroupOperation(operations: [persistOperation, operation])
        group.addObserver(NetworkObserver())
        operationQueue.addOperation(group)
    }

    private func queryPersistedEvents() {
        guard let resultsController = resultsController else { return }
        try! resultsController.performFetch()
        client?.presenterDidChangeState(.value)
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
