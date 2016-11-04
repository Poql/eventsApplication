//
//  ModifyMessageViewController.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 04/11/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
    static let textViewMinimumHeight: CGFloat = 100
}

protocol ModifyMessageViewControllerDelegate: class {
    func controller(controller: ModifyMessageViewController, wantsToModify message: Message)
}

class ModifyMessageViewController: SharedViewController, UITextViewDelegate {

    @IBOutlet var notifyUserSwitch: UISwitch!

    @IBOutlet var notifyUserLabel: UILabel!

    @IBOutlet var contentTextView: UITextView!

    @IBOutlet var contentTextViewHeightConstraint: NSLayoutConstraint!

    @IBOutlet var authorTextField: UITextField!

    @IBOutlet var cancelButton: UIBarButtonItem!

    @IBOutlet var validButton: UIBarButtonItem!

    @IBOutlet var scrollView: UIScrollView!

    weak var delegate: ModifyMessageViewControllerDelegate?

    var message: Message?

    private lazy var keyboardManager: KeyboardManager = {
        return KeyboardManager(scrollView: self.scrollView)
    }()

    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setupViews()
        if message == nil {
            self.message = Message()
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        contentTextView.becomeFirstResponder()
        tryToEnableAddButton()
        keyboardManager.registerForKeyboardMoves()
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        keyboardManager.unregisterForKeyboardMoves()
    }

    // MARK: - Private

    private func setupController() {
        title = String(key: "modify_message_title")
    }

    private func setupViews() {
        scrollView.alwaysBounceVertical = true
        validButton.title = String(key: "add_button_title")
        cancelButton.title = String(key: "cancel_button_title")
        authorTextField.placeholder = String(key: "message_author_label_placeholder")
        notifyUserLabel.text = String(key: "notify_user_label")
        contentTextView.delegate = self
        contentTextView.scrollEnabled = false
        contentTextView.text = message?.content
        authorTextField.text = message?.author
        notifyUserSwitch.on = message?.notify ?? false
    }

    private func tryToEnableAddButton() {
        validButton.enabled = (message?.author ?? "") != "" && (message?.content ?? "") != ""
    }

    // MARK: - UITextViewDelegate

    func textViewDidChange(textView: UITextView) {
        let contentHeight = textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.max)).height
        let minContentHeight = Constant.textViewMinimumHeight
        contentTextViewHeightConstraint.constant = contentHeight > minContentHeight ? contentHeight : minContentHeight
        message?.content = textView.text
        tryToEnableAddButton()
    }

    @IBAction func authorTextFieldDidChange(sender: UITextField) {
        message?.author = sender.text
        tryToEnableAddButton()
    }
    // MARK: - Actions

    @IBAction func notifyUserSwitchAction(sender: UISwitch) {
        message?.notify = sender.on
    }


    @IBAction func cancelButtonItemAction(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func validButtonItemAction(sender: UIBarButtonItem) {
        guard  let message = message else { return }
        dismissViewControllerAnimated(true) { _ in
            self.delegate?.controller(self, wantsToModify: message)
        }
    }
}
