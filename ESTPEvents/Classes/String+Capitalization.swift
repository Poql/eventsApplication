//
//  String+Capitalization.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 12/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

extension String {
    func firstLetterCapitalizedString() -> String {
        let first = String(characters.prefix(1)).uppercaseString
        let other = String(characters.dropFirst())
        return first + other
    }
}
