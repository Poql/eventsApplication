//
//  TextCell.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 09/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

class TextCell: UITableViewCell {
    @IBOutlet var label: UILabel!
    
    @IBOutlet var valueLabel: UILabel! {
        didSet {
            valueLabel.textColor = .darkGrayColor()
        }
    }

    func configure(withLabel text: String?, value: String?) {
        label.text = text
        valueLabel.text = value
    }
}
