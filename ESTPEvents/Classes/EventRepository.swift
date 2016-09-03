//
//  EventRepository.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 02/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

protocol QueryEventsOperationPrototype: class {
    var events: [Event] { get }
    var completionHandler: ((result: Result<[Event], ApplicationError>) -> Void)? { get set }
}

protocol EventRepository {
}
