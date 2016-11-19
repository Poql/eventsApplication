//
//  MainPresenterImplementation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 13/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations


class MainPresenterImplementation<Repository: UserStatusRepository>: ConfigurationPresenter<Repository>, MainPresenter {

    weak var client: MainPresenterClient?

    override init(repository: Repository) {
        super.init(repository: repository)
    }

    // MARK: - ConfigurationPresenter

    func updateCurrentStateFile() {
        updateCurrentStateFile(showLoading: true)
    }

    override func presenterDidDiscoverInvalidApplicationVersion() {
        client?.presenterDidDiscoverInvalidApplicationVersion()
    }
}                                                                                                                                                                                         
