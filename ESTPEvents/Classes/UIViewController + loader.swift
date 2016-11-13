//
//  UIViewController + loader.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 12/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

extension UIViewController {
    static func fromStoryboard<T: UIViewController>() -> T {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(String(T)) as! T
    }
}
