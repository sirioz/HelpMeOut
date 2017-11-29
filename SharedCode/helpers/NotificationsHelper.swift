//
//  NotificationsHelper.swift
//
//  Created by Sirio Zuelli on 28/11/17.
//  Copyright © 2017 Sirio Zuelli. All rights reserved.
//

import Foundation
import UIKit
import UserNotifications
import FirebaseMessaging

class NotificationHelper {
    
    let application: UIApplication
    let cloudFunctions: CloudFunctions
    
    init(application: UIApplication, cloudFunctions: CloudFunctions) {
        self.application = application
        self.cloudFunctions = cloudFunctions
    }
    
    func setupRemoteNotifications() {
        
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
    }
    
    func sendCurrentUserFCMToken() {
        guard let token = Messaging.messaging().fcmToken else { return }
        
        if let userId = cloudFunctions.currentUser?.uid {
            Log.debug("Sending FCM token: \(token)")
            cloudFunctions.setAPNS(token, userType: Constants.userType, forUserId: userId)
        }
    }
    
    func didReceiveRemoteNotification(userInfo: [AnyHashable: Any]) {
        
        guard let aps = userInfo["aps"] as? NSDictionary else { return }
        var body = ""
        var title = NSLocalizedString("notification.title", comment: "")
        if let content = aps["alert"] as? NSDictionary {
            body = content["body"] as? String ?? ""
            title = content["title"] as? String ?? title
        } else {
            body = aps["alert"] as? String ?? ""
        }
        if let vc = application.keyWindow?.rootViewController {
            UIAlertController.showNoAction(on: vc, title: title, message: body)
        }
    }
    
}
