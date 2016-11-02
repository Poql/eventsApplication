//
//  MessageTableViewCell.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 28/10/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet private var descriptionLabel: UILabel!

    @IBOutlet private var authorLabel: UILabel!

    @IBOutlet private var dateLabel: UILabel!

    @IBOutlet var indicatorView: CircleView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    private func setupView() {
        indicatorView.fillColor = .darkGrayColor()
        indicatorView.borderColor = .darkGrayColor()
    }

    private let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "dd/MM"
        return formatter
    }()

    func configure(with model: Message) {
        descriptionLabel.text = model.content
        authorLabel.text = model.author
        dateLabel.text = dateFormatter.stringFromDate(model.creationDate)
    }
}
