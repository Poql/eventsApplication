//
//  MessagesPresenterImplementation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 26/10/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations
import BNRCoreDataStack

class MessagesPresenterImplementation<MR: MessagesRepository, PR: PersistencyRepository>: MessagesPresenter, RecordsFetcherControllerDelegate, RecordsFetcherControllerInitializer {

    private let operationQueue = OperationQueue()

    private let messagesRepository: MR
    private let persistentRepository: PR

    var fetcherController: RecordsFetcherController<MessageRecordMapper>?
    var fetcherControllerPredicate: NSPredicate = .alwaysTrue()
    var fetcherControllerSortDescriptors: [NSSortDescriptor] = []
    var fetcherControllerSectionPath: String? = nil

    weak var client: MessagesPresenterClient?

    init(messagesRepository: MR, persistentRepository: PR) {
        self.messagesRepository = messagesRepository
        self.persistentRepository = persistentRepository
    }

    // MARK: - Private

    private func queryRemoteMessagesOperation() -> Operation {
        let messagesOperation = messagesRepository.queryMessagesRepository()
        let persistOperation = persistentRepository.persistMessagesOperation()
        (persistOperation as Operation).addDependency(messagesOperation)
        messagesOperation.addWillFinishBlock { persistOperation.messages = messagesOperation.messages }
        let group = GroupOperation(operations: [persistOperation, messagesOperation])
        group.addObserver(NetworkObserver())
        return group
    }

    private func queryOperationObserver() -> BlockObserverOnMainQueue {
        return BlockObserverOnMainQueue(
            willExecute: { _ in
                self.client?.presenterWantsToShowLoading()
            },
            didFinish: { _, errors in
                if let err = ErrorMapper.applicationError(fromOperationErrors: errors) {
                    self.client?.presenterMessagesWantsToShowError(err)
                }
            }
        )
    }

    // MARK: - RecordsFetcherControllerDelegate

    func fetcherControllerWillChange() {
        client?.presenterMessagesWillChange()
    }

    func fetcherControllerDidChange() {
        client?.presenterMessagesDidChange()
    }

    func fetcherControllerIsEmpty() {
        client?.presenterMessagesIsEmpty()
    }

    func fetcherControllerHasValues() {
        client?.presenterMessagesDidFill()
    }

    func fetcherControllerRecordDidChange(entityChange: EntityChange) {
        client?.presenterMessagesDidChange(entityChange)
    }

    func fetcherControllerSectionDidChange(sectionChange: EntitySectionChange) {
        client?.presenterMessagesSectionDidChange(sectionChange)
    }

    // MARK: - MessagesPresenter

    func queryMessages() {
        let pOperation = initialiseFetcherControllerOperation(with: self)
        let operation = queryRemoteMessagesOperation()
        operation.addDependency(pOperation)
        let group = GroupOperation(operations: [pOperation, operation])
        group.addObserver(queryOperationObserver())
        operationQueue.addOperation(group)
    }

    func title(forSection section: Int) -> String? {
        return fetcherController?.title(forSection: section)
    }

    func message(atIndex index: NSIndexPath) -> Message {
        return fetcherController?.entity(atIndex: index) ?? Message()
    }

    func numberOfSections() -> Int {
        return fetcherController?.numberOfSections() ?? 0
    }

    func numberOfMessages(inSection section: Int) -> Int {
        return fetcherController?.numberOfEntities(inSection: section) ?? 0
    }
}
