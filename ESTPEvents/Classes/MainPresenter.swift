//
//  MainPresenter.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 13/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

protocol MainPresenter {
    var currentStateFile: ApplicationStateFile? { get }
    var applicationIsOpened: Bool { get }
    func updateCurrentStateFile()
}

protocol MainPresenterClient: class {
    func presenterDidDiscoverInvalidApplicationVersion()
}
