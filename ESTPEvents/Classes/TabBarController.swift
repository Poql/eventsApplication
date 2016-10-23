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
        initializeLongPressGestureRecognizer()
    }

    private func initializeLongPressGestureRecognizer(){
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(recognizerAction(_:)))
        recognizer.minimumPressDuration = Constant.minimumPressDuration
        recognizer.numberOfTouchesRequired = Constant.numberOfTouchesRequired
        tabBar.addGestureRecognizer(recognizer)
    }

    // MARK: - Actions

    @objc private func recognizerAction(sender: UILongPressGestureRecognizer) {
        guard sender.state == .Ended else { return }
        performSegue(withIdentifier: .requestAdminRights, sender: self)
    }
}
