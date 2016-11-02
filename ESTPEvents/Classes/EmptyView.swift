//
//  EmptyView.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 02/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
}

class EmptyView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(64)
        label.textAlignment = .Center
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(17)
        label.textAlignment = .Center
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

    // MARK: - Public

    func configure(title title: String, subtitle: String) {
        subtitleLabel.text = subtitle
        titleLabel.text = title
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
