//
//  PersistentOperationQueue.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 02/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations

class PersistentOperationQueue: OperationQueue {
    static let shared = PersistentOperationQueue()

    override init() {
        super.init()
        maxConcurrentOperationCount = 1
    }
}

