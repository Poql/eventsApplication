//
//  ColorTypePickerCollectionViewCell.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 20/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
    static let circleViewPadding: CGFloat = 4.5
    static let selectedCircleViewBorderWidth: CGFloat = 2.5
}

class ColorTypePickerCollectionViewCell: UICollectionViewCell {

    private let selectedIndicatorCircleView = CircleView()
    private let circleView = CircleView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCircleViews()
        setupCircleViewLayouts()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func configure(color color: Color, selected: Bool) {
        let color = UIColor(hex: color.hex)
        circleView.fillColor = color
        selectedIndicatorCircleView.borderColor = selected ? color : UIColor.clearColor()
    }

    // MARK: - Private

    private func setupCircleViews() {
        circleView.borderColor = UIColor.clearColor()
        selectedIndicatorCircleView.borderColor = UIColor.clearColor()
        selectedIndicatorCircleView.fillColor = UIColor.clearColor()
        backgroundColor = UIColor.clearColor()
        contentView.backgroundColor = UIColor.clearColor()
        selectedIndicatorCircleView.lineWidth = Constant.selectedCircleViewBorderWidth
    }

    private func setupCircleViewLayouts() {
        contentView.addSubview(selectedIndicatorCircleView)
        selectedIndicatorCircleView.translatesAutoresizingMaskIntoConstraints = false
        selectedIndicatorCircleView
            .topAnchor
            .constraintEqualToAnchor(contentView.topAnchor, constant: Constant.selectedCircleViewBorderWidth)
            .active = true
        selectedIndicatorCircleView
            .centerYAnchor
            .constraintEqualToAnchor(contentView.centerYAnchor)
            .active = true
        selectedIndicatorCircleView.widthAnchor.constraintEqualToAnchor(selectedIndicatorCircleView.heightAnchor).active = true
        selectedIndicatorCircleView.centerXAnchor.constraintEqualToAnchor(contentView.centerXAnchor).active = true
        selectedIndicatorCircleView.addSubview(circleView)
        let padding = Constant.circleViewPadding
        circleView.pinToSuperView(with: UIEdgeInsets(top: padding, left: padding, bottom: -padding, right: -padding))
    }
}
