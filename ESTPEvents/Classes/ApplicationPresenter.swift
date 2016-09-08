//
//  ApplicationPresenter.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 07/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import UIKit

protocol ApplicationPresenter {
    func deleteEvents(beforeDate date: NSDate)
    func ensureNotifications()
    func handleRemoteNotification(withUserInfo userInfo: [NSObject : AnyObject], completionHandler: (UIBackgroundFetchResult) -> Void)
}
