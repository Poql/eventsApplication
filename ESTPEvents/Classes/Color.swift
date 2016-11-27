//
//  Color.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 20/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

protocol Color {
    var hex: String { get }
}

protocol MajorColor: Color {
    var declinaisons: [Color] { get }
}
