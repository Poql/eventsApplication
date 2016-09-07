//
//  UITableViewCell + ReusableCell.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 07/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

extension UITableView {
    func dequeueCell<T: UITableViewCell>() -> T {
        return dequeueReusableCellWithIdentifier(String(T)) as! T
    }
}
