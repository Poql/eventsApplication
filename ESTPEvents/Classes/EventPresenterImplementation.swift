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

class EventPresenterImplementation<R: EventRepository, PR: PersistencyRepository>: EventPresenter, FetchedResultsControllerDelegate {
    private let eventRepository: R

    private let persistencyRepository: PR
    
    private let operationQueue = OperationQueue()
    
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
        resultsController = FetchedResultsController<PersistentEvent>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "sectionIdentifier")
        resultsController?.setDelegate(self)
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
    }

    // MARK: - EventPresenter

    func queryAllEvents() {
        queryPersistedEvents()
        queryRemoteEvents()
    }
    
    func numberOfEventSections() -> Int {
        return resultsController?.sections?.count ?? 0
    }
    
    func numberOfEvents(inSection section: Int) -> Int {
        return resultsController?.sections?[section].objects.count ?? 0
    }
    
    func title(forSection section: Int) -> String? {
        return resultsController?.sections?[section].name
    }
    
    func event(atIndex index: NSIndexPath) -> Event {
        return RecordMapper.getEvent(from: resultsController![index])
    }
    
    // MARK: - FetchedResultsControllerDelegate

    func fetchedResultsController(controller: FetchedResultsController<PersistentEvent>, didChangeObject change: FetchedResultsObjectChange<PersistentEvent>) {
        let entityChange: EntityChange
        switch change {
        case let .Delete(object: _, indexPath: indexPath):
            entityChange = .delete(indexPath: indexPath)
        case let .Insert(object: _, indexPath: indexPath):
            entityChange = .insert(indexPath: indexPath)
        case let .Update(object: _, indexPath: indexPath):
            entityChange = .update(indexPath: indexPath)
        case let .Move(object: _, fromIndexPath: fromIndexPath, toIndexPath: toIndexPath):
            entityChange = .move(fromIndexPath: fromIndexPath, toIndexPath: toIndexPath)
        }
        client?.presenterEventDidChange(entityChange)
    }

    func fetchedResultsController(controller: FetchedResultsController<PersistentEvent>, didChangeSection change: FetchedResultsSectionChange<PersistentEvent>) {
        let entitySectionChange: EntitySectionChange
        switch change {
        case let .Insert(_, index):
            entitySectionChange = .insert(index: index)
        case let .Delete(_, index):
            entitySectionChange = .delete(index: index)
        }
        client?.presenterEventSectionDidChange(entitySectionChange)
    }

    func fetchedResultsControllerWillChangeContent(controller: FetchedResultsController<PersistentEvent>) {
        client?.presenterEventsWillChange()
    }

    func fetchedResultsControllerDidChangeContent(controller: FetchedResultsController<PersistentEvent>) {
        client?.presenterEventsDidChange()
    }

    func fetchedResultsControllerDidPerformFetch(controller: FetchedResultsController<PersistentEvent>) {
        client?.presenterDidChangeState(.value)
    }
}
