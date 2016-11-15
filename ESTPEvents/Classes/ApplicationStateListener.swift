//
//  ApplicationStateListener.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 13/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

@objc protocol ApplicationStateListener: class {
    optional func applicationWillEnterForeground()
    optional func applicationDidBecomeActive()
}
