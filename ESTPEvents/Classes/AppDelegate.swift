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
    let presenterFactory = PresenterFactoryImplementation()
    private var applicationPresenter: ApplicationPresenter {
        return presenterFactory.applicationPresenter
    }

    static var shared: AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }

    private var applicationStateListeners = WeakList<ApplicationStateListener>()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        setupNotifications(in: application)
        setupNavigationAppearance()
        removeOldEntities()
        checkUserStatus()
        return true
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        applicationPresenter.handleRemoteNotification(withUserInfo: userInfo, completionHandler: completionHandler)
    }

    func applicationWillEnterForeground(application: UIApplication) {
        applicationStateListeners.forEach { $0.applicationWillEnterForeground?() }
    }

    func applicationDidBecomeActive(application: UIApplication) {
        applicationStateListeners.forEach { $0.applicationDidBecomeActive?() }
    }

    // MARK: - Public

    func addApplicationStateListener(listener: ApplicationStateListener) {
        applicationStateListeners.insert(listener)
    }

    // MARK: - Private

    private func checkUserStatus() {
        applicationPresenter.checkUserStatus()
    }
    
    private func setupNotifications(in application: UIApplication) {
        application.registerForRemoteNotifications()
        applicationPresenter.ensureNotifications()
    }

    private func setupNavigationAppearance() {
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName: UIFont.semiboldHeaderFont(ofSize: 18)]
        UINavigationBar.appearance().barStyle = .Black
        let backIndicatorImage = UIImage(named: "backArrow")?.imageWithAlignmentRectInsets(UIEdgeInsetsMake(0, 0, -2, 0))
        UINavigationBar.appearance().backIndicatorImage = backIndicatorImage
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = backIndicatorImage
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont.regularMainFont(ofSize: 18)], forState: .Normal)
    }

    private func removeOldEntities() {
        applicationPresenter.deleteEvents(beforeDate: NSDate().oneWeekBefore())
        applicationPresenter.deleteMessages(beforeDate: NSDate().twoMonthsBefore())
    }
}

