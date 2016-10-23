//
//  AuthenticationProviderOperation.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 14/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import Operations
import CloudKit

class AuthenticationProviderOperation: GroupOperation {
    private let fetchUserOperation = FetchUserOperation(container: CKContainer.current())

    private var authenticatedOperations: [AuthenticatedOperation] {
        return operations.flatMap { $0 as? AuthenticatedOperation }
    }

    init() {
        super.init(operations: [fetchUserOperation])
    }

    override func operationQueue(queue: OperationQueue, willFinishOperation operation: NSOperation, withErrors errors: [ErrorType]) {
        guard fetchUserOperation == operation else { return }
        authenticatedOperations.forEach { $0.injectUserID(fetchUserOperation.userID) }
    }

    func addAuthenticatedOperation<O: Operation where O: AuthenticatedOperation>(operation: O) {
        (operation as Operation).addDependency(fetchUserOperation)
        addOperation(operation as Operation)
    }
}
