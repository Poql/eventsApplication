//
//  LoadCoreDataStackOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 03/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations
import BNRCoreDataStack

class LoadCoreDataStackOperation: Operation {
    
    private(set) var stack: CoreDataStack?

    override func execute() {
        CoreDataStack.constructSQLiteStack(withModelName: "Model") { result in
            switch result {
            case let .Failure(err):
                self.finish(err)
            case let .Success(stack):
                self.stack = stack
                self.finish()
            }
        }
    }
}
