//
//  ColorCell.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 09/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
    static let colorViewCornerRadius: CGFloat = 8
    static let maximumColorString = 4
    static let hexSymbole = "#"
    static let hexRegex = "^#([A-Fa-f0-9]{0,6}|[A-Fa-f0-9]{0,3})$"
}

class ColorCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet var colorView: UIView!

    @IBOutlet var textField: UITextField!
    
    var colorDidChange: ((color: String?) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.addTarget(self, action: #selector(textFieldAction(_:)), forControlEvents: .EditingChanged)
        textField.delegate = self
        colorView.layer.cornerRadius = Constant.colorViewCornerRadius
    }

    func configure(withPlaceholder placeholder: String?, value: String?) {
        textField.placeholder = placeholder
        textField.text = value
        setColor(fromText: value)
    }

    // MARK: - Private

    private func setColor(fromText text: String?) {
        if let text = text {
            colorView.backgroundColor = UIColor(hex: text)
            return
        }
        colorView.backgroundColor = .lightGrayColor()
    }

    // MARK: - UITextFieldDelegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        guard textField.text?.isEmpty ?? false else { return }
        textField.text = Constant.hexSymbole
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let text = textField.text ?? ""
        let resultingString = (text as NSString).stringByReplacingCharactersInRange(range, withString: string)
        return NSPredicate(format: "SELF MATCHES %@", Constant.hexRegex).evaluateWithObject(resultingString)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        guard textField.text == Constant.hexSymbole else { return }
        textField.text = nil
    }

    // MARK: - UITextFieldAction

    func textFieldAction(sender: UITextField) {
        colorDidChange?(color: textField.text)
        setColor(fromText: textField.text)
    }
}
