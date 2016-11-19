//
//  EventTableViewCell.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 06/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
    static let defaultReadViewColor: String = "646464"
}

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet var readView: CircleView!
    
    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var creatorLabel: UILabel!
    
    @IBOutlet var dateLabel: UILabel!
    
    @IBOutlet var stateLabel: UILabel!
    
    @IBOutlet var descriptionLabel: UILabel!
    
    private let dateFormatter: NSDateFormatter = {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    // MARK: - UIView
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .None
        setFonts()
        setTextColors()
    }
    
    // MARK: - Configuration
    
    func configure(with event: Event) {
        let color = UIColor(hex: event.color ?? Constant.defaultReadViewColor)
        readView.borderColor = color
        readView.fillColor = event.read ? UIColor.whiteColor() : color
        creatorLabel.textColor = color
        creatorLabel.text = event.creator
        titleLabel.text = event.title
        descriptionLabel.text = event.description
        if let date = event.eventDate {
            dateLabel.text = dateFormatter.stringFromDate(date)
        } else {
            dateLabel.text = nil
        }
        stateLabel.text = event.cancelled ? String("event_cancelled_label") : nil
    }

    // MARK: - Private

    private func setFonts() {
        creatorLabel.font = UIFont.mediumHeaderFont(ofSize: 16)
        dateLabel.font = UIFont.mediumHeaderFont(ofSize: 16)
        stateLabel.font = UIFont.mediumMainFont(ofSize: 16)
        titleLabel.font = UIFont.mediumMainFont(ofSize: 16)
        descriptionLabel.font = UIFont.regularMainFont(ofSize: 15)
    }
    
    private func setTextColors() {
        dateLabel.textColor = .blackColor()
        creatorLabel.textColor = .blackColor()
        titleLabel.textColor = .darkGrey()
        stateLabel.textColor = .red()
        descriptionLabel.textColor = .darkGrey()
    }
}
