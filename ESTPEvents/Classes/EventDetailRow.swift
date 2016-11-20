//
//  EventDetailRow.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 12/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

enum EventDetailRow: Int {
    case preview = 0
    case description
    case url
    case location
}

struct EventDetailRowMapper {
    static func row(atIndexPath indexPath: NSIndexPath, forEvent event: Event?) -> EventDetailRow? {
        let hasURL = !(event?.link?.isEmpty ?? true)
        switch indexPath.row {
        case 0:
            return .preview
        case 1:
            return .description
        case 2:
            return hasURL ? .url : .location
        case 3:
            return .location
        default:
            return nil
        }
    }

    static func numberOfRows(forEvent event: Event?) -> Int {
        guard let event = event else { return 0 }
        var count = EventDetailRow.count
        count -= !(event.link?.isEmpty ?? true) ? 0 : 1
        count -= event.location != nil ? 0 : 1
        return count
    }
}
