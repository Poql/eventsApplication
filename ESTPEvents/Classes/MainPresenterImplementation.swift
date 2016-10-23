//
//  MainPresenterImplementation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 19/10/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations

class MainPresenterImplementation<Repository: AdminRepository>: MainPresenter {
    let operationQueue = OperationQueue()

    weak var client: MainPresenterClient?

    let repository: Repository

    init(repository: Repository) {
        self.repository = repository
    }

    func requestToBecomeAdmin() {
        let operation = repository.requestToBecomeAdminOperation()
        let observer = BlockObserverOnMainQueue(
            willExecute: { _ in
                self.client?.presenterWantsToShowLoading()
            },
            didFinish: { op, errors in
                if let error = ErrorMapper.applicationError(fromOperationErrors: errors) {
                    self.client?.presenterWantsToShowError(error)
                } else if operation.adminAlreadyCreated {
                    self.client?.presenterWantsToShowError(.adminAlreadyCreated)
                } else {
                    self.client?.presenterDidRequestToBecomeAdminSuccessfullly()
                }
            }
        )
        operation.addObserver(observer)
        operationQueue.addOperation(operation)
    }
}
