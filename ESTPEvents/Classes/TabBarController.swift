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

class TabBarController: UITabBarController, SegueHandlerType {

    enum SegueIdentifier: String {
        case requestAdminRights = "RequestAdminRightsViewController"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }

    // MARK: - Private

    private func setupController() {
        setupTabBarItems()
        initializeLongPressGestureRecognizer()
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
        tabBar.tintColor = .lightBlue()
        items[0].title = String(key: "event_title")
        items[1].title = String(key: "messages_controller_title")
    }

    // MARK: - Actions

    @objc private func recognizerAction(sender: UILongPressGestureRecognizer) {
        guard sender.state == .Ended else { return }
        performSegue(withIdentifier: .requestAdminRights, sender: self)
    }
}
