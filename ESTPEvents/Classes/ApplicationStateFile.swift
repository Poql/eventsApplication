//
//  ApplicationStateFile.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 13/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

struct ApplicationStateFile {
    let requiredVersion: String
    let tintColor: String

    init?(configurationFile: ConfigurationFile) {
        guard
            let version = configurationFile.requiredVersion,
            let tintColor = configurationFile.tintColor
            else { return nil }
        self = ApplicationStateFile(requiredVersion: version, tintColor: tintColor)
    }

    init(requiredVersion: String, tintColor: String) {
        self.requiredVersion = requiredVersion
        self.tintColor = tintColor
    }
}

extension ApplicationStateFile: Coding {
    var encoded: [String : AnyObject] {
        return [
            "requiredVersion": requiredVersion,
            "tintColor": tintColor
        ]
    }

    init(dict: [String : AnyObject]) {
        requiredVersion = dict["requiredVersion"] as! String
        tintColor = dict["tintColor"] as! String
    }
}
