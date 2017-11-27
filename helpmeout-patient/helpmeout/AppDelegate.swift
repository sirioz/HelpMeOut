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
    var loginCoordinator: LoginCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        setupRemoteNotifications(application)
        setupServices()
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.makeKeyAndVisible()
        window!.rootViewController = UIViewController()
        
        //try? Auth.auth().signOut()
        
//        services.cloudFunctions?.createNewUser(uid: "4uv5FbamwXb3tihe4iSTw9EtKLk2", userType: .patient).done({ shortId in
//            Log.debug("shortId: \(shortId)")
//        })
//        return true;

        if services.cloudFunctions?.isAuthenticated ?? false {
            MainCoordinator(withWindow: self.window!, cloudFunctions: services.cloudFunctions!).start()
        } else {
            loginCoordinator = LoginCoordinator(withWindow: self.window!, delegate: self)
            loginCoordinator!.start()
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
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        guard let aps = userInfo["aps"] as? NSDictionary else { return }
        var body = ""
        var title = NSLocalizedString("notification.title", comment: "")
        if let content = aps["alert"] as? NSDictionary {
            body = content["body"] as? String ?? ""
            title = content["title"] as? String ?? title
        } else {
            body = aps["alert"] as? String ?? ""
        }
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

// MARK: Login delegate
extension AppDelegate: LoginDelegate {
    func didSignInWith(user: User?, error: Error?) {
        if let error = error {
            Log.error(error)
            return
        }
        
        if let user = user {
            services.cloudFunctions?.createNewUser(uid: user.uid, userType: Constants.userType).done({ _ in
                MainCoordinator(withWindow: self.window!, cloudFunctions: self.services.cloudFunctions!).start()
            })
        }
    }
}

