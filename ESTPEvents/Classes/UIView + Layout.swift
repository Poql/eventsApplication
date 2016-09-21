//
//  UIView + Layout.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 15/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

extension UIView {
    func pinToSuperView(with insets: UIEdgeInsets = UIEdgeInsetsZero) {
        guard let superview = superview else { return }
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraintEqualToAnchor(superview.topAnchor, constant: insets.top).active = true
        bottomAnchor.constraintEqualToAnchor(superview.bottomAnchor, constant: insets.bottom).active = true
        leadingAnchor.constraintEqualToAnchor(superview.leadingAnchor, constant: insets.left).active = true
        trailingAnchor.constraintEqualToAnchor(superview.trailingAnchor, constant: insets.right).active = true
    }
}
