//
//  String+Localization.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 07/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

extension String {
    init(key: String) {
        self = NSLocalizedString(key, comment: "")
    }

    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
