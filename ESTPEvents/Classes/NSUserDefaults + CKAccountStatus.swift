//
//  NSUserDefaults + CKAccountStatus.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 22/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import CloudKit

private struct Constant {
    static let key = "AccountStatusUserDefaultKey"
}

extension NSUserDefaults {
    func set(accountStatus status: CKAccountStatus?) {
        setInteger(status?.rawValue ?? 0, forKey: Constant.key)
        synchronize()
    }

    func getAccountStatus() -> CKAccountStatus {
        return CKAccountStatus(rawValue: integerForKey(Constant.key))!
    }
}
