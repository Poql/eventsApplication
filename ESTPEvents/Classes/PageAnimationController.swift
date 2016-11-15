//
//  PageAnimationController.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 12/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
    static let transitionDuration: NSTimeInterval = 0.33
}

class PageAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    @objc func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return Constant.transitionDuration
    }

    @objc func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView()
        guard
            let fromView = transitionContext.viewForKey(UITransitionContextFromViewKey),
            let toView = transitionContext.viewForKey(UITransitionContextToViewKey)
            else { return }
        containerView.addSubview(fromView)
        containerView.addSubview(toView)
        let bounds = containerView.bounds
        fromView.frame = bounds
        toView.frame = bounds
        toView.frame.origin.x = bounds.width

        UIView.animateWithDuration(Constant.transitionDuration, animations: {
            toView.frame.origin.x = 0
            fromView.frame.origin.x = -bounds.width
        }) { finished in
            fromView.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}
