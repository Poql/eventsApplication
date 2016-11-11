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
    
    static func red() -> UIColor {
        return UIColor(red: 208/255, green: 0, blue: 27/255, alpha: 1)
    }

    static func lightOrange() -> UIColor {
        return UIColor(hex: "#F57F17")
    }
    
    static func lightBlue() -> UIColor {
        return UIColor(red: 25/255, green: 118/255, blue: 210/255, alpha: 1)
    }

    static func lightGreen() -> UIColor {
        return UIColor(red: 0/255, green: 230/255, blue: 118/255, alpha: 1)
    }

    static func orange() -> UIColor {
        return UIColor(red: 1, green: 111/255, blue: 29/255, alpha: 1)
    }

    static func darkGrey() -> UIColor {
        return UIColor(white: 64/255, alpha: 1)
    }
}
