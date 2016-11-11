//
//  RequestAdminRightsViewController.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 22/10/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

class RequestAdminRightsViewController: SharedViewController, MainPresenterClient {

    @IBOutlet var cancelButton: UIButton!

    @IBOutlet var titleLabel: UILabel!

    @IBOutlet var subtitleLabel: UILabel!

    @IBOutlet var requestButton: UIButton!

    @IBOutlet var detailsLabel: UILabel!

    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    @IBOutlet var bottomStackView: UIStackView!

    private lazy var mainPresenter: MainPresenter = {
        let presenter = self.presenterFactory.mainPresenter
        self.presenterFactory.addClient(self)
        return presenter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }

    // MARK: - Private

    private func setupController() {
        titleLabel.text = String(key: "request_admin_rights_title")
        subtitleLabel.text = String(key: "request_admin_rights_subtitle")
        detailsLabel.text = String(key: "request_admin_rights_details")
        requestButton.setTitle(String(key: "request_admin_rights_button_title"), forState: .Normal)
        cancelButton.setTitle(String(key: "cancel_button_title"), forState: .Normal)
        cancelButton.addTarget(self, action: #selector(cancelAction(_:)), forControlEvents: .TouchUpInside)
        requestButton.addTarget(self, action: #selector(requestButtonAction(_:)), forControlEvents: .TouchUpInside)
        titleLabel.font = UIFont.regularMainFont(ofSize: 30)
        subtitleLabel.font = UIFont.regularMainFont(ofSize: 17)
        detailsLabel.font = UIFont.regularMainFont(ofSize: 11)
        cancelButton.titleLabel?.font = UIFont.regularHeaderFont(ofSize: 15)
        requestButton.titleLabel?.font = UIFont.regularMainFont(ofSize: 15)
    }

    // MARK: - Action

    @objc private func requestButtonAction(sender: UIButton) {
        mainPresenter.requestToBecomeAdmin()
    }

    @objc private func cancelAction(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - MainPresenterClient

    func presenterWantsToShowError(error: ApplicationError) {
        bottomStackView.hidden = false
        activityIndicator.stopAnimating()
        showAlert(withMessage: error.description, title: String(key: "error_title"))
    }

    func presenterDidRequestToBecomeAdminSuccessfullly() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func presenterWantsToShowLoading() {
        bottomStackView.hidden = true
        activityIndicator.startAnimating()
    }
}
