//
//  EventPresenter.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 02/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

protocol EventModificationListener: class {
    func presenterDidBeginToModify(event event: Event)
    func presenterDidModify(event event: Event)
}

protocol EventPresenter {
    func queryAllEvents()
    func modifyEvent(event: Event)
    func event(atIndex index: NSIndexPath) -> Event
    func title(forSection section: Int) -> String?
    func numberOfEvents(inSection section: Int) -> Int
    func numberOfEventSections() -> Int
}

protocol EventPresenterClient: class {
    func presenterDidChangeState(state: PresenterState<ApplicationError>)
    func presenterEventsWillChange()
    func presenterEventDidChange(eventChange: EntityChange)
    func presenterEventSectionDidChange(eventSectionChange: EntitySectionChange)
    func presenterEventsDidChange()
}
