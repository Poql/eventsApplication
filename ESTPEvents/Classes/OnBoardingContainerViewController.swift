//
//  OnBoardingContainerViewController.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 12/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

class OnboardingContainerViewController: UINavigationController, OnBoardingViewControllerDelegate, UINavigationControllerDelegate, UIViewControllerTransitioningDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarHidden = true
        transitioningDelegate = self
        delegate = self
        let controller: OnBoardingViewController = .fromStoryboard()
        controller.delegate = self
        viewControllers = [controller]
    }

    // MARK: - OnBoardingViewControllerDelegate

    func onBoardingControllerWantsToDismiss(controller: OnBoardingViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func onBoardingControllerWantsToPresentOtherPage(controller: OnBoardingViewController) {
        let controller: OnBoardingViewController = .fromStoryboard()
        controller.delegate = self
        controller.type = .notifications
        pushViewController(controller, animated: true)
    }

    // MARK: - UINavigationControllerDelegate

    func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PageAnimationController()
    }

    // MARK: - UIViewControllerTransitioningDelegate

    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PopAnimationController()
    }
}
