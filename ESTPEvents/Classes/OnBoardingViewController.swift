//
//  OnBoardingViewController.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 12/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
    static let π = M_PI
    static let waitingDuration: CFTimeInterval = 1
    static let decorationAnimationRotationDuration: CFTimeInterval = 0.8
    static let decorationAnimationTranslationDuration: CFTimeInterval = 0.15
    static let decorationAnimationTranslationValue: NSNumber = -15
    static let decorationAnimaionRotationValues = [0, -π/12, π/12, -π/6, π/6, -π/8, π/8, -π/12, π/12, 0]
}

enum OnBoardingType {
    case welcome
    case notifications
}

protocol OnBoardingViewControllerDelegate: class {
    func onBoardingControllerWantsToDismiss(controller: OnBoardingViewController)
    func onBoardingControllerWantsToPresentOtherPage(controller: OnBoardingViewController)
}

class OnBoardingViewController: UIViewController, UIViewControllerTransitioningDelegate {
    var type: OnBoardingType = .welcome

    @IBOutlet var decorationLabel: UILabel!

    @IBOutlet var titleLabel: UILabel!

    @IBOutlet var buttonsStackView: UIStackView!

    @IBOutlet var mainButton: UIButton!

    @IBOutlet var secondButton: UIButton!

    @IBOutlet var descriptionLabel: UILabel!

    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!

    weak var delegate: OnBoardingViewControllerDelegate?

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextColors()
        setupFont()
        setupView()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        guard  type == .notifications else { return }
        animateDecorationLabel()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    // MARK: - Private

    private func setupView() {
        switch type {
        case .notifications:
            decorationLabel.text = "on_boarding_notifications_decoration_label".localized
            titleLabel.text = "on_boarding_notifications_title_label".localized
            mainButton.setTitle("on_boarding_notifications_main_button_title".localized, forState: .Normal)
            secondButton.setTitle("on_boarding_notifications_second_button_title".localized, forState: .Normal)
            descriptionLabel.text = "on_boarding_notifications_description_label".localized
        case .welcome:
            decorationLabel.text = "on_boarding_welcome_decoration_label".localized
            titleLabel.text = "on_boarding_welcome_title_label".localized
            mainButton.setTitle("on_boarding_welcome_main_button_title".localized, forState: .Normal)
            descriptionLabel.text = "on_boarding_welcome_description_label".localized
            secondButton.hidden = true
        }
        mainButton.addTarget(self, action: #selector(mainButtonAction(_:)), forControlEvents: .TouchUpInside)
        secondButton.addTarget(self, action: #selector(secondButtonAction(_:)), forControlEvents: .TouchUpInside)
        secondButton.tintColor = .grayColor()
        view.backgroundColor = .darkGrey()
        activityIndicatorView.hidden = true
    }

    private func setupFont() {
        decorationLabel.font = UIFont.mediumHeaderFont(ofSize: 100)
        titleLabel.font = UIFont.boldHeaderFont(ofSize: 20)
        descriptionLabel.font = UIFont.regularMainFont(ofSize: 15)
        mainButton.titleLabel?.font = UIFont.regularMainFont(ofSize: 28)
        secondButton.titleLabel?.font = UIFont.regularMainFont(ofSize: 13)
    }

    private func setupTextColors() {
        decorationLabel.textColor = .whiteColor()
        titleLabel.textColor = .whiteColor()
        mainButton.titleLabel?.textColor = .whiteColor()
        secondButton.titleLabel?.textColor = .whiteColor()
        descriptionLabel.textColor = .whiteColor()
    }

    private func animateDecorationLabel() {
        let translation = CABasicAnimation(keyPath: "transform.translation.y")
        translation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        translation.beginTime = Constant.waitingDuration
        translation.fromValue = 0
        translation.toValue = Constant.decorationAnimationTranslationValue
        translation.duration = Constant.decorationAnimationTranslationDuration
        translation.fillMode = kCAFillModeForwards
        let rotation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotation.beginTime = Constant.waitingDuration
        rotation.duration = Constant.decorationAnimationRotationDuration
        rotation.values = Constant.decorationAnimaionRotationValues
        rotation.additive = true
        let secondTranslation = CABasicAnimation(keyPath: "transform.translation.y")
        secondTranslation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        secondTranslation.beginTime =  rotation.duration - translation.duration + Constant.waitingDuration
        secondTranslation.fromValue = Constant.decorationAnimationTranslationValue
        secondTranslation.toValue = 0
        secondTranslation.duration = Constant.decorationAnimationTranslationDuration
        let group = CAAnimationGroup()
        group.animations = [translation, rotation, secondTranslation]
        group.duration = rotation.duration + Constant.waitingDuration
        decorationLabel.layer.addAnimation(group, forKey: nil)
    }

    // MARK: - Actions

    @objc private func mainButtonAction(sender: UIButton) {
        switch type {
        case .welcome:
            delegate?.onBoardingControllerWantsToPresentOtherPage(self)
        default:
            delegate?.onBoardingControllerWantsToDismiss(self)
        }
    }

    @objc private func secondButtonAction(sender: UIButton) {
        animateDecorationLabel()
    }

    // MARK: - UIViewControllerTransitioningDelegate

    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PageAnimationController()
    }
}
