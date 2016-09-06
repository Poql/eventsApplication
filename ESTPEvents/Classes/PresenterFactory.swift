//
//  PresenterFactory.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 03/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

protocol PresenterFactory {
    var eventPresenter: EventPresenter { get }
    func addClient(eventClient: EventPresenterClient)
}

class PresenterFactoryImplementation: PresenterFactory {
    
    private let eventRepository = EventRepositoryImplementation()
    
    private let persistencyRepository = PersistencyRepositoryImplementation()
    
    private lazy var eventPresenterImplementation: EventPresenterImplementation<EventRepositoryImplementation, PersistencyRepositoryImplementation> = {
        return EventPresenterImplementation(repository: self.eventRepository, persistencyRepository: self.persistencyRepository)
    }()
    
    // MARK: - PresenterFactory
    
    var eventPresenter: EventPresenter {
        return eventPresenterImplementation
    }
    
    func addClient(eventClient: EventPresenterClient) {
        eventPresenterImplementation.client = eventClient
    }
}
