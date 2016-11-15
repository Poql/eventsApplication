//
//  OnBoardingPresenter.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 13/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

protocol OnBoardingPresenter {
    func fetchApplicationConfiguration()
    func finishApplicationOpening()
    func requestNotifications()
}

protocol OnBoardingPresenterClient: class {
    func presenterDidUpdateTintColor(hex: String)
    func presenterWantsToShowLoading()
    func presenterWantsToShowError(error: ApplicationError)
}
