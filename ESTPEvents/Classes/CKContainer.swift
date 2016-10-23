//
//  CKContainer.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 23/10/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import CloudKit

extension CKContainer {
    static func current() -> CKContainer {
        return CKContainer(identifier: currentID)
    }

    static var currentID: String {
        return "iCloud.com.gzanella.ESTPEvents"
    }
}
