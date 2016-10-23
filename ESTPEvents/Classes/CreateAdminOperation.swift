//
//  CreateAdminOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 16/10/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import CloudKit

class CreateAdminOperation: ModifyRecordsOperation, AuthenticatedOperation {
    var resultingAdmin: Admin? {
        guard let record = savedRecords?.first else { return nil }
        return Admin(record: record)
    }

    var userID: CKRecordID? {
        didSet {
            guard let userID = userID else { return }
            self.admin = Admin()
            admin?.userReference = CKReference(recordID: userID, action: .None)
            admin?.accepted = false
        }
    }

    var admin: Admin? {
        get {
            guard let record = recordsToSave?.first else { return nil }
            return Admin(record: record)
        }
        set {
            if let admin = newValue {
                recordsToSave = [admin.record]
            } else {
                recordsToSave = nil
            }
        }
    }

    init() {
        super.init(recordsToSave: nil, recordIDsToDelete: nil, database: CKContainer.current().publicCloudDatabase)
        addCondition(AuthenticatedCondition())
    }
}
