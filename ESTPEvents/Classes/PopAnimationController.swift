//
//  PopAnimationController.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 12/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
    static let transitionDuration: NSTimeInterval = 0.6
    static let dismissingScale: CGFloat = 0.9
    static let presentingScale: CGFloat = 1.3
}

class PopAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return Constant.transitionDuration
    }

    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        guard
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
            else { return }
        containerView.addSubview(toView)
        containerView.addSubview(fromView)

        let bounds = containerView.bounds
        toView.frame = bounds
        fromView.frame = bounds
        toView.transform = CGAffineTransformMakeScale(Constant.dismissingScale, Constant.dismissingScale)
        UIView.animateWithDuration(Constant.transitionDuration, animations: {
            fromView.transform = CGAffineTransformMakeScale(Constant.presentingScale, Constant.presentingScale)
            fromView.alpha = 0
            toView.transform = CGAffineTransformIdentity
        }) { finished in
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
