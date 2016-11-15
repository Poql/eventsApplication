//
//  ApplicationPresenter.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 07/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import UIKit

protocol UserStatusUpdateListener {
    func userStatusDidUpdate(userStatus: UserStatus)
}

protocol ApplicationPresenter: class {
    var currentUserStatus: UserStatus { get }

    func deleteMessages(beforeDate date: NSDate)
    func deleteEvents(beforeDate date: NSDate)
    func ensureNotifications()
    func handleRemoteNotification(withUserInfo userInfo: [NSObject : AnyObject], completionHandler: (UIBackgroundFetchResult) -> Void)
    func checkUserStatus()
    func registerForUserStatusUpdate(listener: UserStatusUpdateListener)
}
