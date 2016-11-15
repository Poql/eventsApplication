//
//  TabBarController.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 19/10/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
    static let minimumPressDuration: NSTimeInterval = 0.5
    static let numberOfTouchesRequired = 1
}

class TabBarController: UITabBarController, SegueHandlerType, MainPresenterClient, TintColorSetter, ApplicationStateListener {

    enum SegueIdentifier: String {
        case requestAdminRights = "RequestAdminRightsViewController"
    }

    private var presenterFactory: PresenterFactory {
        return AppDelegate.shared.presenterFactory
    }

    private lazy var presenter: MainPresenter = {
        let presenter = self.presenterFactory.mainPresenter
        self.presenterFactory.addClient(self)
        return presenter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        if let color = presenter.currentStateFile?.tintColor {
            setTintColor(color)
        }
    }

    override func viewDidAppear(animated: Bool) {
        if !presenter.applicationIsOpened {
            let controller = OnboardingContainerViewController()
            presentViewController(controller, animated: false, completion: nil)
        }
        super.viewDidAppear(animated)
    }

    // MARK: - ApplicationStateListener

    func applicationWillEnterForeground() {
        guard presenter.applicationIsOpened else { return }
        presenter.updateCurrentStateFile()
    }

    // MARK: - MainPresenterClient

    func presenterWantsToUpdateTintColor(hex: String) {
        setTintColor(hex)
        setCurrentTintColor(hex)
    }

    func presenterDidDiscoverInvalidApplicationVersion() {
        guard let _ = presentedViewController else { return }
        dismissViewControllerAnimated(true) {
            self.presentViewController(NeedUpdateViewController(), animated: true, completion: nil)
        }
    }

    // MARK: - Private

    private func setCurrentTintColor(color: String) {
        tabBar.tintColor = UIColor(hex: color)
    }

    private func setupController() {
        setupTabBarItems()
        initializeLongPressGestureRecognizer()
        AppDelegate.shared.addApplicationStateListener(self)
    }

    private func initializeLongPressGestureRecognizer(){
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(recognizerAction(_:)))
        recognizer.minimumPressDuration = Constant.minimumPressDuration
        recognizer.numberOfTouchesRequired = Constant.numberOfTouchesRequired
        tabBar.addGestureRecognizer(recognizer)
    }

    private func setupTabBarItems() {
        guard let items = tabBar.items else { return }
        tabBar.barStyle = .Black
        items[0].title = String(key: "event_title")
        items[1].title = String(key: "messages_controller_title")
    }

    // MARK: - Actions

    @objc private func recognizerAction(sender: UILongPressGestureRecognizer) {
        guard sender.state == .Ended else { return }
        performSegue(withIdentifier: .requestAdminRights, sender: self)
    }
}
