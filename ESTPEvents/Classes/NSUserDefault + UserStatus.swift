//
//  NSUserDefault + UserStatus.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 13/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

private struct Constant {
    static let userStatusKey = "UserStatusKey"
}

extension NSUserDefaults {
    func set(userStatus userStatus: UserStatus?) {
        setInteger(userStatus?.rawValue ?? 0, forKey: Constant.userStatusKey)
        synchronize()
    }

    func userStatus() -> UserStatus? {
        return UserStatus(rawValue: integerForKey(Constant.userStatusKey))
    }
}
