//
//  FetchAdminOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 13/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations
import CloudKit

class FetchAdminOperation: QueryOperation, AuthenticatedOperation {
    var userID: CKRecordID?

    var resultingAdmin: Admin? {
        if let record = fetchedRecords.first {
            return Admin(record: record)
        }
        return nil
    }

    init() {
        super.init(query: nil)
        addCondition(AuthenticatedCondition())
    }

    func injectUserID(userID: CKRecordID?) {
        self.userID = userID
        if let userID = userID {
            let reference = CKReference(recordID: userID, action: .None)
            let predicate = NSPredicate(format: "userReference == %@", reference)
            query = CKQuery(record: Admin.self, predicate: predicate)
            return
        }
        query = nil
    }
}
