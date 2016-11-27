//
//  ColorPickerCollectionViewCell.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 26/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
    static let cornerRadius: CGFloat = 4
    static let trailingLabel: CGFloat = 10
}

class ColorPickerCollectionViewCell: UICollectionViewCell {

    private let tenorView = UIView()

    private let label = UILabel()

    // MARK: - UICollectionViewCell

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func configure(color color: Color) {
        let backgroundColor = UIColor(hex: color.hex)
        tenorView.backgroundColor = backgroundColor
        label.text = color.hex
        label.textColor = UIColor.textColor(forBackgroundColor: backgroundColor)
    }

    // MARK: - Private

    private func setupView() {
        contentView.addSubview(tenorView)
        tenorView.pinToSuperView()
        tenorView.layer.cornerRadius = Constant.cornerRadius
        tenorView.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraintEqualToAnchor(tenorView.centerYAnchor).active = true
        label.trailingAnchor.constraintEqualToAnchor(tenorView.trailingAnchor, constant: -Constant.trailingLabel).active = true
        label.font = UIFont.regularMainFont(ofSize: 16)
    }
}
