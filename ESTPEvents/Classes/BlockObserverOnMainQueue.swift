//
//  BlockObserverOnMainQueue.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 15/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations

class BlockObserverOnMainQueue: OperationWillExecuteObserver, OperationDidFinishObserver {
    private let blockObserver: BlockObserver
    init(willExecute: WillExecuteObserver.BlockType? = .None, didFinish: DidFinishObserver.BlockType? = .None) {
        self.blockObserver = BlockObserver(
            willExecute: { op in
                dispatch_async(dispatch_get_main_queue()) {
                    willExecute?(operation: op)
                }
            },
            willCancel: nil, didCancel: nil, didProduce: nil, willFinish: nil,
            didFinish: { op, errs in
                dispatch_async(dispatch_get_main_queue()) {
                    didFinish?(operation: op, errors: errs)
                }
        })
    }

    func willExecuteOperation(operation: Operation) {
        blockObserver.willExecuteOperation(operation)
    }

    func didFinishOperation(operation: Operation, errors: [ErrorType]) {
        blockObserver.didFinishOperation(operation, errors: errors)
    }
}
