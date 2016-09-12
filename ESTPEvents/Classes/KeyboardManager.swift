//
//  KeyboardManager.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 12/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

protocol KeyboardManagerDelegate: class {
    func managerNeedsActiveRect() -> CGRect?
}

class KeyboardManager {
    let scrollView: UIScrollView

    weak var delegate: KeyboardManagerDelegate?

    init(scrollView: UIScrollView) {
        self.scrollView = scrollView
    }

    func registerForKeyboardMoves() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardDidShow(_:)), name: UIKeyboardDidShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }

    func unregisterForKeyboardMoves() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    @objc private func keyboardDidShow(notification: NSNotification) {
        let userInfo: NSDictionary = notification.userInfo!
        let keyboardSize = userInfo.objectForKey(UIKeyboardFrameEndUserInfoKey)!.CGRectValue.size
        var contentInsets = scrollView.contentInset
        var scrollIndicatorInsets = scrollView.scrollIndicatorInsets
        contentInsets.bottom = keyboardSize.height
        scrollIndicatorInsets.bottom = keyboardSize.height
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = scrollIndicatorInsets
        showVisibleRect()
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animateWithDuration(0.33) {
            self.scrollView.contentInset = UIEdgeInsetsZero
        }
        scrollView.scrollIndicatorInsets = UIEdgeInsetsZero
    }
    private func showVisibleRect() {
        guard let rect = delegate?.managerNeedsActiveRect() else { return }
        scrollView.scrollRectToVisible(rect, animated: false)
    }
}
