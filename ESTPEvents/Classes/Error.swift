//
//  Error.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 02/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

enum ApplicationError: ErrorType {
    case generic
    case notDiscoverable
    case notAuthorized
    case notConnected

    var description: String {
        switch self {
        case .generic:
            return String(key: "error_generic_message")
        case .notAuthorized:
            return String(key: "error_not_authorized_message")
        case .notConnected:
            return String(key: "error_not_connected_message")
        case .notDiscoverable:
            return String(key: "error_not_discoverable_message")
        }
    }
}

enum OperationError: ErrorType {
    case generic
    case noContext
    case subscriptionAlreadySubmitted
    case notAuthenticated
    case adminNotAccepted
}
