//
//  MessagesPresenter.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 26/10/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

protocol MessagesPresenter  {
    func message(atIndex index: NSIndexPath) -> Message
    func title(forSection section: Int) -> String?
    func numberOfMessages(inSection section: Int) -> Int
    func numberOfSections() -> Int
    func queryMessages()
}

protocol MessagesPresenterClient: class {
    func presenterMessagesWantsToShowError(error: ApplicationError)
    func presenterMessagesIsEmpty()
    func presenterWantsToShowLoading()
    func presenterMessagesDidFill()
    func presenterMessagesWillChange()
    func presenterMessagesDidChange(eventChange: EntityChange)
    func presenterMessagesSectionDidChange(eventSectionChange: EntitySectionChange)
    func presenterMessagesDidChange()
}
