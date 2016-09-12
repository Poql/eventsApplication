//
//  Location+MapKit.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 11/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation
import MapKit

extension Location {
    init(location: MKLocalSearchCompletion) {
        self.title = location.title
        self.subtitle = location.subtitle
    }
}
