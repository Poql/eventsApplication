//
//  Operation+Error.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 02/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations

extension Operation {
    func addCompletionBlockOnMainQueue(block: () -> Void) {
        addCompletionBlock {
            dispatch_async(dispatch_get_main_queue()) {
                block()
            }
        }
    }

    func addWillFinishBlock(block: () -> Void) {
        let observer = BlockObserver(willFinish: { _,_ in
            block()
        })
        addObserver(observer)
    }
}
