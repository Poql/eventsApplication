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
    var applicationPresenter: ApplicationPresenter { get }
    func addClient(eventClient: EventPresenterClient)
}

class PresenterFactoryImplementation: PresenterFactory {
    
    private let eventRepository = EventRepositoryImplementation()
    
    private let persistencyRepository = PersistencyRepositoryImplementation()
    
    private let subscriptionRepository = SubscriptionRepositoryImplementation()

    private let userStatusRepository = UserStatusRepositoryImplementation()
    
    private lazy var eventPresenterImplementation: EventPresenterImplementation<EventRepositoryImplementation, PersistencyRepositoryImplementation> = {
        return EventPresenterImplementation(repository: self.eventRepository, persistencyRepository: self.persistencyRepository)
    }()
    
    private lazy var applicationPresenterImplementation: ApplicationPresenterImplementation<PersistencyRepositoryImplementation, SubscriptionRepositoryImplementation, UserStatusRepositoryImplementation> = {
        return ApplicationPresenterImplementation(persistencyRepository: self.persistencyRepository, subscriptionRepository: self.subscriptionRepository, userStatusRepository: self.userStatusRepository)
    }()
    
    // MARK: - PresenterFactory
    
    var applicationPresenter: ApplicationPresenter {
        return applicationPresenterImplementation
    }
    
    var eventPresenter: EventPresenter {
        return eventPresenterImplementation
    }
    
    func addClient(eventClient: EventPresenterClient) {
        eventPresenterImplementation.client = eventClient
    }
}
