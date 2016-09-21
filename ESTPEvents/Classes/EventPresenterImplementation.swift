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

    private var resultsControllerIsEmpty: Bool {
        return resultsController?.fetchedObjects?.isEmpty ?? true
    }

    weak var client: EventPresenterClient?
    
    init(repository: R, persistencyRepository: PR) {
        self.eventRepository = repository
        self.persistencyRepository = persistencyRepository
    }

    // MARK: - Private

    private func queryPersistedEventsOperation() -> Operation {
        let operation = DataStackBlockOperation { stack in
            guard let mainContext = stack?.mainQueueContext else { return }
            self.setResultsController(with: mainContext)
            self.queryPersistedEvents()
        }
        let provider = DataStackProviderOperation()
        provider.userIntent = .Initiated
        provider.addDataStackOperation(operation)
        return provider
    }
    
    private func setResultsController(with context: NSManagedObjectContext) {
        let request = NSFetchRequest(entity: PersistentEvent.self)
        request.sortDescriptors = [NSSortDescriptor(key: "eventDate", ascending: true), NSSortDescriptor(key: "eventDescription", ascending: true)]
        resultsController = FetchedResultsController<PersistentEvent>(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: "sectionIdentifier")
        resultsController?.setDelegate(self)
    }

    private func queryRemoteEventsOperation() -> Operation {
        let operation = eventRepository.queryEventsOperation()
        let persistOperation = persistencyRepository.persistEventsOperation()
        (persistOperation as Operation).addDependency(operation)
        operation.addWillFinishBlock {
            persistOperation.events = operation.events
        }
        let group = GroupOperation(operations: [persistOperation, operation])
        group.addObserver(NetworkObserver())
        group.addObserver(queryRemoteEventsObserver())
        return group
    }

    private func queryRemoteEventsObserver() -> BlockObserverOnMainQueue {
        return BlockObserverOnMainQueue(willExecute: { _ in
            self.client?.presenterWantsToShowLoading()
            }, didFinish: { _, errors in
                self.client?.presenterWantsToDismissLoading()
                if let err = ErrorMapper.applicationError(fromOperationErrors: errors) {
                    self.client?.presenterWantsToShowError(err)
                }
                if self.resultsControllerIsEmpty {
                    self.client?.presenterIsEmpty()
                }
        })
    }
    }

    private func queryPersistedEvents() {
        guard let resultsController = resultsController else { return }
        try! resultsController.performFetch()
    }

    // MARK: - EventPresenter

    func queryAllEvents() {
        let persistedEventsOperation = queryPersistedEventsOperation()
        let remoteEventsOperation = queryRemoteEventsOperation()
        remoteEventsOperation.addDependency(persistedEventsOperation)
        operationQueue.addOperations(persistedEventsOperation, remoteEventsOperation)
    }

    func modifyEvent(event: Event) {
        let operation = eventRepository.modifyEventOperation(event: event)
        let persistentOperation = persistencyRepository.persistEventsOperation()
        operation.addWillFinishBlock {
            guard let resultingEvent = operation.resultingEvent else { return }
            persistentOperation.events = [resultingEvent]
        }
        (persistentOperation as Operation).addDependency(operation)
        let groupOperation = GroupOperation(operations: operation, persistentOperation)
        groupOperation.addObserver(NetworkObserver())
        operationQueue.addOperation(groupOperation)
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
        if resultsControllerIsEmpty {
            client?.presenterIsEmpty()
        }
    }

    func fetchedResultsControllerDidPerformFetch(controller: FetchedResultsController<PersistentEvent>) {
        if resultsControllerIsEmpty {
            client?.presenterIsEmpty()
            return
        }
        client?.presenterHasValues()
    }
}
