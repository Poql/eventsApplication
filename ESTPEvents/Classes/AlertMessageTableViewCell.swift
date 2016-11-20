//
//  AlertMessageTableViewCell.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 19/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

class AlertMessageTableViewCell: UITableViewCell {

    @IBOutlet var authorLabel: UILabel!

    @IBOutlet var dateLabel: UILabel!

    @IBOutlet var contentLabel: UILabel!

    @IBOutlet var tenorView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    // MARK: - Private

    private func setupView() {
        authorLabel.textColor = .whiteColor()
        dateLabel.textColor = .whiteColor()
        contentLabel.textColor = .whiteColor()
        selectionStyle = .None
        authorLabel.font = UIFont.boldHeaderFont(ofSize: 16)
        dateLabel.font = UIFont.boldHeaderFont(ofSize: 16)
        contentLabel.font = UIFont.regularMainFont(ofSize: 16)
        tenorView.backgroundColor = AppDelegate.shared.window?.tintColor
    }

    // MARK: - Configuration

    func configure(with model: Message) {
        authorLabel.text = model.author
        contentLabel.text = model.content
        dateLabel.text = NSDateFormatter.basicDateString(from: model.creationDate)
    }
}
