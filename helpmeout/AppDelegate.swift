//
//  AppDelegate.swift
//  helpmeout
//
//  Created by Sirio Zuelli on 21/11/17.
//  Copyright © 2017 Sirio Zuelli. All rights reserved.
//

import UIKit
import Firebase
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let services = Services()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        setupRemoteNotifications(application)
        setupServices()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.makeKeyAndVisible()
        window!.rootViewController = UIViewController()
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                MainCoordinator(withWindow: self.window!).start()
            } else {
                LoginCoordinator(withWindow: self.window!).start()
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

}

// MARK: Setup
extension AppDelegate {
    
    func setupServices() {
        services.cloudFunctions = FirCloudFunctions()
    }
}

// MARK: Notifications
extension AppDelegate: MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        guard let token = Messaging.messaging().fcmToken else { return }
        Log.debug("FCM token: \(token)")
                
        if let userId = services.cloudFunctions?.currentUser?.uid {
            services.cloudFunctions?.setAPNS(token, userType: Constants.userType, forUserId: userId)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        guard let aps = userInfo["aps"] as? NSDictionary else { return }
        let body = (aps["alert"] as? String) ?? ""
        let title = NSLocalizedString("notification.title", comment: "")
        if let vc = window?.rootViewController {
            UIAlertController.showNoAction(on: vc, title: title, message: body)
        }
    }
    
}

extension AppDelegate {
    
    fileprivate func setupRemoteNotifications(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
    }
}

