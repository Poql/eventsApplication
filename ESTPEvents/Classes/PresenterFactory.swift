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
    var mainPresenter: MainPresenter { get }
    var messagesPresenter: MessagesPresenter { get }
    func addClient(eventClient: EventPresenterClient)
    func addClient(mainClient: MainPresenterClient)
    func addClient(messagesClient: MessagesPresenterClient)
}

class PresenterFactoryImplementation: PresenterFactory {
    
    private let eventRepository = EventRepositoryImplementation()
    
    private let persistencyRepository = PersistencyRepositoryImplementation()
    
    private let subscriptionRepository = SubscriptionRepositoryImplementation()

    private let userStatusRepository = UserStatusRepositoryImplementation()

    private let adminRepository = AdminRepositoryImplementation()

    private let messagesRepository = MessagesRepositoryImplementation()
    
    private lazy var eventPresenterImplementation: EventPresenterImplementation<EventRepositoryImplementation, PersistencyRepositoryImplementation> = {
        return EventPresenterImplementation(repository: self.eventRepository, persistencyRepository: self.persistencyRepository)
    }()
    
    private lazy var applicationPresenterImplementation: ApplicationPresenterImplementation<PersistencyRepositoryImplementation, SubscriptionRepositoryImplementation, UserStatusRepositoryImplementation> = {
        return ApplicationPresenterImplementation(persistencyRepository: self.persistencyRepository, subscriptionRepository: self.subscriptionRepository, userStatusRepository: self.userStatusRepository)
    }()

    private lazy var mainPresenterImplementation: MainPresenterImplementation<AdminRepositoryImplementation> = {
        return MainPresenterImplementation(repository: self.adminRepository)
    }()

    private lazy var messagesPresenterImplementation: MessagesPresenterImplementation<MessagesRepositoryImplementation, PersistencyRepositoryImplementation> = {
        return MessagesPresenterImplementation(messagesRepository: self.messagesRepository, persistentRepository: self.persistencyRepository)
    }()
    
    // MARK: - PresenterFactory
    
    var applicationPresenter: ApplicationPresenter {
        return applicationPresenterImplementation
    }
    
    var eventPresenter: EventPresenter {
        return eventPresenterImplementation
    }

    var mainPresenter: MainPresenter {
        return mainPresenterImplementation
    }

    var messagesPresenter: MessagesPresenter {
        return messagesPresenterImplementation
    }

    func addClient(mainClient: MainPresenterClient) {
        mainPresenterImplementation.client = mainClient
    }
    
    func addClient(eventClient: EventPresenterClient) {
        eventPresenterImplementation.client = eventClient
    }

    func addClient(messagesClient: MessagesPresenterClient) {
        messagesPresenterImplementation.client = messagesClient
    }
}
