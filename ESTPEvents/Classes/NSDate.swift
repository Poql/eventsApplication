//
//  NSDate.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 04/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

private struct Constant {
    static let weekTimeInterval: NSTimeInterval = 60 * 60 * 24 * 7
    static let monthTimeInterval: NSTimeInterval = weekTimeInterval * 4
}

extension NSDate {
    func oneWeekBefore() -> NSDate {
        return dateByAddingTimeInterval(-Constant.weekTimeInterval)
    }

    func oneMonthBefore() -> NSDate {
        return dateByAddingTimeInterval(-Constant.monthTimeInterval)
    }

    func twoMonthsBefore() -> NSDate {
        return dateByAddingTimeInterval(-Constant.monthTimeInterval * 2)
    }
}
