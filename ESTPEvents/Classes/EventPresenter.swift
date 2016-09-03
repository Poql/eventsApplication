//
//  EventPresenter.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 02/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

protocol EventPresenter {
    var events: [Event] { get }
    func queryAllEvents()
}

protocol EventPresenterClient: class {
    func presenterDidQueryEvents()
}
