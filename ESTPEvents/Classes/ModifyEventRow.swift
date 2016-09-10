//
//  ModifyEventRow.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 08/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

enum ModifyEventSection: Int {
    case preview = 0
    case creator
    case detail
    case adjunct
}

enum ModifyEventPreviewRow: Int {
    case title = 0
    case type
}

enum ModifyEventDetailRow: Int {
    case date = 0
    case notify
}

enum ModifyEventAdjunctRow: Int {
    case url
    case description
}

enum ModifyEventCreatorRow: Int {
    case creator = 0
    case color
}
