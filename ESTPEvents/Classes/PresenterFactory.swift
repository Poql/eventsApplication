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
    var requestAdminRightsPresenter: RequestAdminRightsPresenter { get }
    var messagesPresenter: MessagesPresenter { get }
    var onBoardingPresenter: OnBoardingPresenter { get }
    var mainPresenter: MainPresenter { get }
    func addClient(eventClient: EventPresenterClient)
    func addClient(requestAdminRightsClient: RequestAdminRightsPresenterClient)
    func addClient(messagesClient: MessagesPresenterClient)
    func addClient(onBoarding: OnBoardingPresenterClient)
    func addClient(mainClient: MainPresenterClient)
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

    private lazy var requestAdminRightsPresenterImplementation: RequestAdminRightsPresenterImplementation<AdminRepositoryImplementation> = {
        return RequestAdminRightsPresenterImplementation(repository: self.adminRepository)
    }()

    private lazy var messagesPresenterImplementation: MessagesPresenterImplementation<MessagesRepositoryImplementation, PersistencyRepositoryImplementation> = {
        return MessagesPresenterImplementation(messagesRepository: self.messagesRepository, persistentRepository: self.persistencyRepository)
    }()

    private lazy var onBoardingPresenterImplementation: OnBoardingPresenterImplementation<UserStatusRepositoryImplementation> = {
        return OnBoardingPresenterImplementation(repository: self.userStatusRepository)
    }()

    private lazy var mainPresenterImplementation: MainPresenterImplementation<UserStatusRepositoryImplementation> = {
        return MainPresenterImplementation(repository: self.userStatusRepository)
    }()
    
    // MARK: - PresenterFactory
    
    var applicationPresenter: ApplicationPresenter {
        return applicationPresenterImplementation
    }
    
    var eventPresenter: EventPresenter {
        return eventPresenterImplementation
    }

    var requestAdminRightsPresenter: RequestAdminRightsPresenter {
        return requestAdminRightsPresenterImplementation
    }

    var messagesPresenter: MessagesPresenter {
        return messagesPresenterImplementation
    }

    var onBoardingPresenter: OnBoardingPresenter {
        return onBoardingPresenterImplementation
    }

    var mainPresenter: MainPresenter {
        return mainPresenterImplementation
    }

    func addClient(requestAdminRightsClient: RequestAdminRightsPresenterClient) {
        requestAdminRightsPresenterImplementation.client = requestAdminRightsClient
    }
    
    func addClient(eventClient: EventPresenterClient) {
        eventPresenterImplementation.client = eventClient
    }

    func addClient(messagesClient: MessagesPresenterClient) {
        messagesPresenterImplementation.client = messagesClient
    }

    func addClient(onBoardingClient: OnBoardingPresenterClient) {
        onBoardingPresenterImplementation.client = onBoardingClient
    }

    func addClient(mainClient: MainPresenterClient) {
        mainPresenterImplementation.client = mainClient
    }
}
