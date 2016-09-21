//
//  EmptyEventView.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 14/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
}

class EmptyEventView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(64)
        label.textAlignment = .Center
        label.text = String(key: "empty_event_title_label")
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(17)
        label.textAlignment = .Center
        label.text = String(key: "empty_event_subtitle_label")
        return label
    }()

    init() {
        super.init(frame: CGRectZero)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }

    // MARK: - Private

    private func setupViews() {
        let view = UIStackView()
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.bottomAnchor.constraintEqualToAnchor(centerYAnchor).active = true
        view.centerXAnchor.constraintEqualToAnchor(centerXAnchor).active = true
        view.leadingAnchor.constraintGreaterThanOrEqualToAnchor(leadingAnchor).active = true
        view.axis = .Vertical
        view.addArrangedSubview(titleLabel)
        view.addArrangedSubview(subtitleLabel)
    }
}
