//
//  PersistentRecordMapper.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 26/10/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

protocol PersistentRecordMapper {
    associatedtype R: Entity, Record
    associatedtype PR: PersistentRecord

    static func getRecord(from persistentRecord: PR) -> R
}
