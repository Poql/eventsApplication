//
//  UIColor.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 07/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hex: String, alpha: Float = 1.0){
        let string = hex.stringByReplacingOccurrencesOfString("#", withString: "")
        
        let scanner = NSScanner(string: string)
        
        var color:UInt32 = 0
        
        scanner.scanHexInt(&color)
        
        let mask = 0x000000FF
        
        let red = CGFloat(Float(Int(color >> 16) & mask) / 255.0)
        let green = CGFloat(Float(Int(color >> 8) & mask) / 255.0)
        let blue = CGFloat(Float(Int(color) & mask) / 255.0)
        
        self.init(red: red, green: green, blue: blue, alpha: CGFloat(alpha))
    }
}
