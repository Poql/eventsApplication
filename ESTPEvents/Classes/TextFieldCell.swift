//
//  TextFieldCell.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 08/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var textField: UITextField!

    var textFieldDidChange: ((text: String?) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.addTarget(self, action: #selector(textFieldAction(_:)), forControlEvents: .EditingChanged)
    }

    // MARK: - Configuration

    func configure(withLabel label: String?, placeholder: String?, text: String?) {
        titleLabel.hidden = label == nil
        titleLabel.text = label
        textField.placeholder = placeholder
        textField.text = text
    }
    
    // MARK: - Actions
    
    func textFieldAction(sender: UITextField) {
        textFieldDidChange?(text: sender.text)
    }
}
