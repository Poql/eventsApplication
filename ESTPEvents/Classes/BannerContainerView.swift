//
//  BannerContainerView.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 15/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
    static let bannerHeight: CGFloat = 30
    static let bannerLeftInsets: CGFloat = 20
    static let bannerAnimationDuration: NSTimeInterval = 0.25
}

protocol BannerContainerViewDelegate: class {
    func bannerViewDidShow(animated animated: Bool)
    func bannerViewDidHide()
}

class BannerContainerView: UIView {

    weak var delegate: BannerContainerViewDelegate?

    private(set) var animationDuration: NSTimeInterval = Constant.bannerAnimationDuration
    let bannerHeight = Constant.bannerHeight

    private var heightConstraint: NSLayoutConstraint!

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(12, weight: UIFontWeightBold)
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
            delegate?.bannerViewDidShow(animated: false)
            return
        }
        UIView.animateWithDuration(animationDuration, animations: {
            self.superview?.layoutIfNeeded()
        }) { _ in
            self.delegate?.bannerViewDidShow(animated: true)
        }
    }

    func hideBanner() {
        heightConstraint.constant = 0
        UIView.animateWithDuration(animationDuration, animations: {
            self.superview?.layoutIfNeeded()
        }) { _ in
            self.delegate?.bannerViewDidHide()
        }
    }

    // MARK: - Private

    private func setupViews() {
        clipsToBounds = true
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
