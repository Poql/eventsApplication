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
