//
//  Coding.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 13/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import Foundation

protocol Coding {
    init(dict: [String : AnyObject])
    var encoded: [String : AnyObject] { get }
}
