//
//  AppDelegate.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 02/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
    static let weekTimeInterval: NSTimeInterval = 60 * 60 * 24 * 7
    static let notificationSettings = UIUserNotificationSettings(forTypes: .Alert, categories: nil)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private let presenterFactory = PresenterFactoryImplementation()


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupNotifications(in: application)
        setupNavigationAppearance()
        setPresenterFactory()
        removeOldEvents()
        return true
    }
    
    // MARK: - Private
    
    private func setupNotifications(in application: UIApplication) {
        application.registerForRemoteNotifications()
        application.registerUserNotificationSettings(Constant.notificationSettings)
        presenterFactory.applicationPresenter.ensureNotifications()
    }
    
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
    
    private func removeOldEvents() {
        presenterFactory.applicationPresenter.deleteEvents(beforeDate: NSDate().dateByAddingTimeInterval(-Constant.weekTimeInterval))
    }
}

