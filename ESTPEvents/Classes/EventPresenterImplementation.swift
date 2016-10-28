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

class EventPresenterImplementation<R: EventRepository, PR: PersistencyRepository>: EventPresenter, RecordsFetcherControllerDelegate, RecordsFetcherControllerInitializer {
    private let eventRepository: R

    private let persistencyRepository: PR
    
    private let operationQueue = OperationQueue()

    var fetcherController: RecordsFetcherController<EventRecordMapper>?
    var fetcherControllerPredicate: NSPredicate = .alwaysTrue()
    var fetcherControllerSortDescriptors = [
        NSSortDescriptor(key: "eventDate", ascending: true),NSSortDescriptor(key: "eventDescription", ascending: true)
    ]
    var fetcherControllerSectionPath: String? = "sectionIdentifier"

    private var eventListeners = WeakList<EventModificationListener>()
    private var modifyingEvents = Set<Event>()

    weak var client: EventPresenterClient?
    
    init(repository: R, persistencyRepository: PR) {
        self.eventRepository = repository
        self.persistencyRepository = persistencyRepository
    }

    // MARK: - Private

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
            self.client?.eventPresenterWantsToShowLoading()
            }, didFinish: { _, errors in
                if let err = ErrorMapper.applicationError(fromOperationErrors: errors) {
                    self.client?.eventPresenterWantsToShowError(err)
                }
//                if self.resultsControllerIsEmpty {
//                    self.client?.presenterIsEmpty()
//                }
        })
    }

    private func modifyEventObserver(event event: Event) -> BlockObserverOnMainQueue {
        return BlockObserverOnMainQueue(willExecute: { _ in
            self.eventListeners.forEach { $0.presenterDidBeginToModify(event: event) }
            self.modifyingEvents.insert(event)
            }, didFinish: { op, errors in
            self.eventListeners.forEach { $0.presenterDidModify(event: event) }
            self.modifyingEvents.remove(event)
            if let err = ErrorMapper.applicationError(fromOperationErrors: errors) {
                self.client?.eventPresenterWantsToShowError(err)
            }
        })
    }

    // MARK: - EventPresenter

    func registerListener(listener: EventModificationListener) {
        eventListeners.insert(listener)
    }

    func isModifyingEvent(event: Event) -> Bool {
        return modifyingEvents.contains(event)
    }

    func queryAllEvents() {
        let persistedEventsOperation = initialiseFetcherControllerOperation(with: self)
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
        groupOperation.addObserver(modifyEventObserver(event: event))
        operationQueue.addOperation(groupOperation)
    }

    func title(forSection section: Int) -> String? {
        return fetcherController?.title(forSection: section)
    }

    func event(atIndex index: NSIndexPath) -> Event {
        return fetcherController?.entity(atIndex: index) ?? Event()
    }

    func numberOfEventSections() -> Int {
        return fetcherController?.numberOfSections() ?? 0
    }

    func numberOfEvents(inSection section: Int) -> Int {
        return fetcherController?.numberOfEntities(inSection: section) ?? 0
    }

    // MARK: - RecordsFetcherControllerDelegate

    func fetcherControllerWillChange() {
        client?.eventPresenterWillChange()
    }

    func fetcherControllerDidChange() {
        client?.eventPresenterDidChange()
    }

    func fetcherControllerIsEmpty() {
        client?.eventPresenterIsEmpty()
    }

    func fetcherControllerHasValues() {
        client?.eventPresenterDidFill()
    }

    func fetcherControllerRecordDidChange(entityChange: EntityChange) {
        client?.eventPresenterDidChange(entityChange)
    }

    func fetcherControllerSectionDidChange(sectionChange: EntitySectionChange) {
        client?.eventPresenterSectionDidChange(sectionChange)
    }
}
