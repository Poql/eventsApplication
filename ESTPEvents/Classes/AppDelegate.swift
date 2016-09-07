//
//  AppDelegate.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 02/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let presenterFactory = PresenterFactoryImplementation()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupNavigationAppearance()
        setPresenterFactory()
        return true
    }
    
    // MARK: - Private
    
    private func setPresenterFactory() {
        guard let controller = window?.rootViewController as? EventViewController else { return }
        controller.presenterFactory = presenterFactory
        window?.rootViewController = NavigationControllerWithWhiteStatusBar(rootViewController: controller)
    }
    
    private func setupNavigationAppearance() {
        UINavigationBar.appearance().barTintColor = .lightBlue()
        UINavigationBar.appearance().tintColor = .whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
}

