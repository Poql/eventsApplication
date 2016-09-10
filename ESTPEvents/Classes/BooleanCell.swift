//
//  BooleanCell.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 08/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

class BooleanCell: UITableViewCell {
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var switchView: UISwitch!
    
    var switchDidChange: ((state: Bool) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        switchView.addTarget(self, action: #selector(switchAction(_:)), forControlEvents: .EditingChanged)
        switchView.onTintColor = .lightBlue()
    }
 
    func configure(withLabel text: String?, selected: Bool) {
        titleLabel.text = text
        switchView.on = selected
    }

    // MARK: - Actions

    func switchAction(sender: UISwitch) {
        switchDidChange?(state: sender.on)
    }
}
