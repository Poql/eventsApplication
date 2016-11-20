//
//  NSDateFormatter.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 19/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

extension NSDateFormatter {
    static func basicDateString(from date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter.stringFromDate(date)
    }
}
