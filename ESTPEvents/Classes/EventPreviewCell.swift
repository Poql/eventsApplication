//
//  EventPreviewCell.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 12/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

class EventPreviewCell: UITableViewCell {

    @IBOutlet var dateLabel: UILabel!

    @IBOutlet var titleLabel: UILabel!

    @IBOutlet var typeLabel: UILabel!

    @IBOutlet var creatorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupFonts()
    }

    private let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "fr")
        dateFormatter.dateFormat = "EEEE d MMMM"
        return dateFormatter
    }()

    // MARK: - Public

    func configure(event event: Event?) {
        if let date = event?.eventDate {
            dateLabel.text = dateFormatter.stringFromDate(date).firstLetterCapitalizedString()
        } else {
            dateLabel.text = nil
        }
        titleLabel.text = event?.title
        typeLabel.text = event?.type
        creatorLabel.text = event?.creator
        if let hex = event?.color {
            let color = UIColor(hex: hex)
            typeLabel.textColor = color
            creatorLabel.textColor = color
            return
        }
        creatorLabel.textColor = .darkGrayColor()
        typeLabel.textColor = .darkGrayColor()
    }

    // MARK: - Private

    private func setupFonts() {
        dateLabel.font = UIFont.mediumHeaderFont(ofSize: 17)
        titleLabel.font = UIFont.boldHeaderFont(ofSize: 17)
        creatorLabel.font = UIFont.mediumMainFont(ofSize: 15)
        typeLabel.font = UIFont.mediumMainFont(ofSize: 15)
        creatorLabel.textColor = .darkGrayColor()
        typeLabel.textColor = .darkGrayColor()
    }
}
