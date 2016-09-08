//
//  Error+CloudKit.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 08/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import CloudKit

extension NSError {
    func partialErrors() -> [String : NSError]? {
        return userInfo[CKPartialErrorsByItemIDKey] as? [String : NSError]
    }
}

func ==(error: NSError, cloudKitError: CKErrorCode) -> Bool {
    return error.domain == CKErrorDomain && error.code == cloudKitError.rawValue
}
