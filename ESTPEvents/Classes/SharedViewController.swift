//
//  SharedViewController.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 02/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

protocol Info {
    var identifier: Int { get }
    var description: String { get }
    var color: UIColor { get }
}

extension Info {
    var color: UIColor { return .orange() }
}

class SharedViewController: UIViewController, UserStatusUpdateListener, BannerContainerViewDelegate {
    var presenterFactory: PresenterFactory {
        return AppDelegate.shared.presenterFactory
    }

    private var identifiers: [Int] = []
    private var currentInfo: [Int : Info] = [:]

    private let bannerContainer = BannerContainerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBanner()
        userStatusDidUpdate(presenterFactory.applicationPresenter.currentUserStatus)
        presenterFactory.applicationPresenter.registerForUserStatusUpdate(self)
    }

    // MARK: - Private

    func setupBanner() {
        edgesForExtendedLayout = UIRectEdge.None
        view.addSubview(bannerContainer)
        bannerContainer.delegate = self
        bannerContainer.translatesAutoresizingMaskIntoConstraints = false
        bannerContainer.topAnchor.constraintEqualToAnchor(topLayoutGuide.topAnchor).active = true
        bannerContainer.leadingAnchor.constraintEqualToAnchor(view.leadingAnchor).active = true
        bannerContainer.trailingAnchor.constraintEqualToAnchor(view.trailingAnchor).active = true
    }

    // MARK: - BannerContainerViewDelegate

    func bannerViewDidHide() {
        guard let tableview = view.subviews.first as? UITableView else { return }
        UIView.animateWithDuration(bannerContainer.animationDuration) {
            tableview.contentInset.top = tableview.contentInset.top - self.bannerContainer.bannerHeight
        }
    }

    func bannerViewDidShow(animated animated: Bool) {
        guard let tableview = view.subviews.first as? UITableView else { return }
        if !animated {
            tableview.contentInset.top = tableview.contentInset.top + self.bannerContainer.bannerHeight
            return
        }
        UIView.animateWithDuration(bannerContainer.animationDuration) {
            tableview.contentInset.top = tableview.contentInset.top + self.bannerContainer.bannerHeight
        }
    }

    // MARK: - UserStatusUpdateListener

    func userStatusDidUpdate(userStatus: UserStatus) {
    }

    // MARK: - Public

    func showAlert(withMessage message: String, title: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let doneAction = UIAlertAction(title: String(key: "done_action_label"), style: .Default) { _ in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(doneAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    func showBanner(with info: Info, animated: Bool = true) {
        identifiers.append(info.identifier)
        currentInfo[info.identifier] = info
        bannerContainer.showBanner(with: info.description, color: info.color, animated: animated)
    }

    func dismissBannerInfo(info: Info) {
        guard let i = identifiers.indexOf(info.identifier) else { return }
        identifiers.removeAtIndex(i)
        currentInfo.removeValueForKey(i)
        if let identifier = identifiers.last, let info = currentInfo[identifier] {
            showBanner(with: info)
            return
        }
        bannerContainer.hideBanner()
    }
}

