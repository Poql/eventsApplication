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
        setFonts()
        setTextColors()
    }
    
    // MARK: - Configuration
    
    func configure(with event: Event) {
        let color = UIColor(hex: event.color ?? Constant.defaultReadViewColor)
        readView.borderColor = color
        readView.fillColor = color
        titleLabel.text = event.title
        creatorLabel.text = event.creator
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
        dateLabel.font = UIFont.systemFontOfSize(17, weight: UIFontWeightMedium)
        creatorLabel.font = UIFont.systemFontOfSize(17)
        titleLabel.font = UIFont.systemFontOfSize(15, weight: UIFontWeightMedium)
        stateLabel.font = UIFont.systemFontOfSize(15, weight: UIFontWeightMedium)
        descriptionLabel.font = UIFont.systemFontOfSize(15)
    }
    
    private func setTextColors() {
        dateLabel.textColor = .blackColor()
        creatorLabel.textColor = .blackColor()
        titleLabel.textColor = .darkGrayColor()
        stateLabel.textColor = .red()
        descriptionLabel.textColor = .darkGrayColor()
    }
}
