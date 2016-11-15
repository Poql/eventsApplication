//
//  TintColorSetter.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 13/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

protocol TintColorSetter {
    func setTintColor(color: String)
}

extension TintColorSetter {
    func setTintColor(color: String) {
        let color = UIColor(hex: color)
        UINavigationBar.appearance().tintColor = color
        UIBarButtonItem.appearance().tintColor = color
        UIButton.appearance().tintColor = color
        UITabBar.appearance().tintColor = color
        UISwitch.appearance().onTintColor = color
    }
}
