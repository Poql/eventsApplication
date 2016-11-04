//
//  MessagesRepositoryImplementation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 23/10/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

class MessagesRepositoryImplementation: MessagesRepository {
    func queryMessagesRepository() -> QueryMessagesOperation {
        return QueryMessagesOperation()
    }

    func modifyMessageOperation(message: Message) -> ModifyMessageOperation {
        return ModifyMessageOperation(message: message)
    }
}
