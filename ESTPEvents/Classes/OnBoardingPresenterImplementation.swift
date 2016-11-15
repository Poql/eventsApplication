//
//  OnBoardingPresenterImplementation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 13/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit


private struct Constant {
    static let notificationSettings = UIUserNotificationSettings(forTypes: .Alert, categories: nil)
}

class OnBoardingPresenterImplementation<Repository: UserStatusRepository>: ConfigurationPresenter<Repository>, OnBoardingPresenter {
    weak var client: OnBoardingPresenterClient?

    override init(repository: Repository) {
        super.init(repository: repository)
    }

    // MARK: - OnBoardingPresenter

    func fetchApplicationConfiguration() {
        updateCurrentStateFile()
    }

    func requestNotifications() {
        UIApplication.sharedApplication().registerUserNotificationSettings(Constant.notificationSettings)
    }

    // MARK: - ConfigurationPresenter

    override func presenterDidBeginUpdatingConfigurationFile() {
        client?.presenterWantsToShowLoading()
    }

    override func presenterDidUpdateTintColor(colorHex: String) {
        client?.presenterDidUpdateTintColor(colorHex)
    }

    override func presenterDidFail(with error: ApplicationError) {
        client?.presenterWantsToShowError(error)
    }
}
