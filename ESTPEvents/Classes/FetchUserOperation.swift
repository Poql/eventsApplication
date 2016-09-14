//
//  FetchUserOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 13/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import CloudKit
import Operations

class FetchUserOperation: Operation {
    let container: CKContainer

    private(set) var userID: CKRecordID?

    init(container: CKContainer) {
        self.container = container
        super.init()
    }

    override func execute() {
        container.fetchUserRecordIDWithCompletionHandler { userID, error in
            self.userID = userID
            self.finish(error)
        }
    }
}
