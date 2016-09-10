//
//  TextViewCell.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 08/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

class TextViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet var textView: UITextView!
    
    var placeholder = ""
    
    var textViewDidChange: ((text: String?) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    // MARK: - Configuration

    func configure(placeholder placeholder: String, text: String?) {
        self.placeholder = placeholder
        textView.text = text ?? placeholder
        textView.textColor = text == nil ? .lightGrayColor() : .blackColor()
    }

    // MARK: - Private

    private func setupViews() {
        textView.delegate = self
    }

    // MARK: - UITextViewDelegate

    func textViewDidBeginEditing(textView: UITextView) {
        if textView.text == placeholder && textView.textColor == .lightGrayColor() {
            textView.text = nil
            textView.textColor = .blackColor()
        }
    }

    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = placeholder
            textView.textColor = .lightGrayColor()
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        textViewDidChange?(text: textView.text)
    }
}
