//
//  EventPresenterImplementation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 02/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations

class EventPresenterImplementation<Repository: EventRepository>: EventPresenter {
    private(set) var events: [Event] = []
    
    func queryAllEvents() {
    }
}
