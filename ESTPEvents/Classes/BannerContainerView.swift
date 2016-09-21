//
//  BannerContainerView.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 15/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
    static let bannerHeight: CGFloat = 25
    static let bannerLeftInsets: CGFloat = 20
    static let bannerAnimationDuration: NSTimeInterval = 1
}

protocol BannerContainerViewDelegate: class {
    func bannerViewDidShow()
    func bannerViewDidHide()
}

class BannerContainerView: UIView {

    weak var delegate: BannerContainerViewDelegate?

    private(set) var animationDuration: NSTimeInterval = Constant.bannerAnimationDuration

    private var heightConstraint: NSLayoutConstraint!

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(12, weight: UIFontWeightMedium)
        label.textColor = .whiteColor()
        return label
    }()

    private let bannerView: UIView = {
        let view = UIView()
        return view
    }()

    init() {
        super.init(frame: CGRectZero)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public

    func showBanner(with message: String, color: UIColor = .red(), animated: Bool) {
        messageLabel.text = message
        bannerView.backgroundColor = color
        guard heightConstraint.constant < Constant.bannerHeight else { return }
        heightConstraint.constant = Constant.bannerHeight
        if !animated {
            layoutIfNeeded()
            return
        }
        UIView.animateWithDuration(animationDuration) {
            self.layoutIfNeeded()
        }
    }

    func hideBanner() {
        heightConstraint.constant = 0
        UIView.animateWithDuration(animationDuration) {
            self.layoutIfNeeded()
        }
    }

    // MARK: - Private

    private func setupViews() {
        addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        let stackView = UIStackView(arrangedSubviews: [messageLabel])
        bannerView.addSubview(stackView)
        stackView.pinToSuperView(with: UIEdgeInsetsMake(0, Constant.bannerLeftInsets, 0, 0))
        bannerView.bottomAnchor.constraintEqualToAnchor(bottomAnchor).active = true
        bannerView.leadingAnchor.constraintEqualToAnchor(leadingAnchor).active = true
        bannerView.trailingAnchor.constraintEqualToAnchor(trailingAnchor).active = true
        bannerView.heightAnchor.constraintEqualToConstant(Constant.bannerHeight).active = true
        heightConstraint = heightAnchor.constraintEqualToConstant(0)
        heightConstraint.active = true
    }
}