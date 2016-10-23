//
//  MainPresenter.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 19/10/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

protocol MainPresenter {
    func requestToBecomeAdmin()
}

protocol MainPresenterClient: class {
    func presenterWantsToShowError(error: ApplicationError)
    func presenterWantsToShowLoading()
    func presenterDidRequestToBecomeAdminSuccessfullly()
}
