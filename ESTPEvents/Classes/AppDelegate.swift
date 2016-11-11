//
//  AppDelegate.swift
//  ESTPEvents
//
//  Created by Gaétan Zanella on 02/09/2016.
//  Copyright © 2016 Gaétan Zanella. All rights reserved.
//

import UIKit

private struct Constant {
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
        removeOldEntities()
        checkUserStatus()
        return true
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        applicationPresenter.handleRemoteNotification(withUserInfo: userInfo, completionHandler: completionHandler)
    }

    func applicationDidBecomeActive(application: UIApplication) {
        applicationPresenter.checkCurrentVersion { currentVersionIsValid in
            guard !currentVersionIsValid else { return }
            self.showNeedUpdateViewController()
        }
    }
    
    // MARK: - Private

    private func showNeedUpdateViewController() {
        guard let controller = window?.rootViewController else { return }
        if let _ = controller.presentedViewController as? NeedUpdateViewController {
            return
        }
        controller.presentViewController(NeedUpdateViewController(), animated: true, completion: nil)
    }

    private func checkUserStatus() {
        applicationPresenter.checkUserStatus()
    }
    
    private func setupNotifications(in application: UIApplication) {
        application.registerForRemoteNotifications()
        application.registerUserNotificationSettings(Constant.notificationSettings)
        applicationPresenter.ensureNotifications()
    }

    private func setupNavigationAppearance() {
        UINavigationBar.appearance().tintColor = .lightBlue()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName: UIFont.regularHeaderFont(ofSize: 18)]
        UINavigationBar.appearance().barStyle = .Black
    }
    
    private func removeOldEntities() {
        applicationPresenter.deleteEvents(beforeDate: NSDate().oneWeekBefore())
        applicationPresenter.deleteMessages(beforeDate: NSDate().twoMonthsBefore())
    }
}

