//
//  AuthenticatedOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 13/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations
import CloudKit

protocol AuthenticatedOperation: class {
    var userID: CKRecordID? { get set }
    func injectUserID(userID: CKRecordID?)
}

extension AuthenticatedOperation {
    func injectUserID(userID: CKRecordID?) {
        self.userID = userID
    }
}
