//
//  ApplicationPresenterImplementation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 07/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations

class ApplicationPresenterImplementation<PR: PersistencyRepository>: ApplicationPresenter {
    let operationQueue = OperationQueue()
    let persistencyRepository: PR
    
    init(persistencyRepository: PR) {
        self.persistencyRepository = persistencyRepository
    }

    func deleteEvents(beforeDate date: NSDate) {
        let operation = persistencyRepository.deleteEventsOperation(limitDate: date)
        operationQueue.addOperation(operation)
    }
}
