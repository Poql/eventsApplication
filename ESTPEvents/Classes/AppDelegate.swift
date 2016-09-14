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
    let presenterFactory = PresenterFactoryImplementation()
    private var applicationPresenter: ApplicationPresenter {
        return presenterFactory.applicationPresenter
    }

    static var shared: AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupNotifications(in: application)
        setupNavigationAppearance()
        removeOldEvents()
        checkUserStatus()
        return true
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        applicationPresenter.handleRemoteNotification(withUserInfo: userInfo, completionHandler: completionHandler)
    }
    
    // MARK: - Private

    private func checkUserStatus() {
        applicationPresenter.checkUserStatus()
    }
    
    private func setupNotifications(in application: UIApplication) {
        application.registerForRemoteNotifications()
        application.registerUserNotificationSettings(Constant.notificationSettings)
        applicationPresenter.ensureNotifications()
    }

    private func setupNavigationAppearance() {
        UINavigationBar.appearance().barTintColor = .lightBlue()
        UINavigationBar.appearance().tintColor = .whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
    }
    
    private func removeOldEvents() {
        applicationPresenter.deleteEvents(beforeDate: NSDate().dateByAddingTimeInterval(-Constant.weekTimeInterval))
    }
}

