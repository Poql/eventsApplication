//
//  ApplicationPresenter.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 07/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

protocol ApplicationPresenter {
    func deleteEvents(beforeDate date: NSDate)
    func ensureNotifications()
}
