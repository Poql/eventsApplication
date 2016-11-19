//
//  EventTableViewHeader.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 11/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

class EventTableViewHeader: UITableViewHeaderFooterView {

    private let label = UILabel()
    private let separator = SeparatorView()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup

    private func setupView() {
        contentView.backgroundColor = UIColor.darkGrey()
        label.font = UIFont.regularMainFont(ofSize: 17)
        label.textColor = UIColor.whiteColor()
        contentView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraintEqualToAnchor(contentView.centerYAnchor).active = true
        label.centerXAnchor.constraintEqualToAnchor(contentView.centerXAnchor).active = true
        label.leadingAnchor.constraintEqualToAnchor(contentView.leadingAnchor, constant: 20).active = true
        separator.color = .whiteColor()
        addSubview(separator)
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.heightAnchor.constraintEqualToConstant(1).active = true
        separator.leadingAnchor.constraintEqualToAnchor(leadingAnchor)
        separator.trailingAnchor.constraintEqualToAnchor(trailingAnchor)
        separator.bottomAnchor.constraintEqualToAnchor(bottomAnchor)
    }

    // MARK: - Public

    func configure(title title: String?) {
        label.text = title
    }
}
