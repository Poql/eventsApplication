//
//  SequenceType + Record.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 07/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

extension SequenceType where Generator.Element: Record {
    func recordNames() -> [String] {
        return self.map { $0.record.recordID.recordName }
    }
}
