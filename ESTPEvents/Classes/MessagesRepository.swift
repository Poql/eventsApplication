//
//  MessagesRepository.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 23/10/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations

protocol QueryMessagesOperationPrototype {
    var messages: [Message] { get }
}

protocol MessagesRepository {
    associatedtype QueryMessagesOperation: Operation, QueryMessagesOperationPrototype

    func queryMessagesRepository() -> QueryMessagesOperation
}
