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
    var notificationsHelper: NotificationHelper?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let isTest = NSClassFromString("XCTest") != nil
        if isTest {
            initTestDB()
            return true
        }
        
        FirebaseApp.configure()
        setupServices()
        Messaging.messaging().delegate = self
        notificationsHelper = NotificationHelper(application: application, cloudFunctions: services.cloudFunctions!)
        notificationsHelper?.delegate = self
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.makeKeyAndVisible()
        window!.rootViewController = UIViewController()

        if services.cloudFunctions?.isAuthenticated ?? false {
            MainCoordinator(withWindow: self.window!, cloudFunctions: services.cloudFunctions!).start()
        } else {
            loginCoordinator = LoginCoordinator(withWindow: self.window!, cloudFunctions: services.cloudFunctions!)
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
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        notificationsHelper?.didReceiveRemoteNotification(userInfo: userInfo)
    }
    
}

extension AppDelegate: NotificationDelegate {

    func didReceivePushData(userInfo: NSDictionary?, title: String?, body: String?) {
        
        if let opType = userInfo?["opType"] as? String {
            switch opType {
            case "pReq":
                if let vc = window?.rootViewController! {
                    UIAlertController.showConfirm(on: vc, title: title ?? "", message: body ?? "", actionTitle: NSLocalizedString("Confirm", comment: ""), actionStyle: .default, cancelActionTitle: NSLocalizedString("Cancel", comment: "")) {
                        if let shortId = userInfo?["patientShortId"] as? String {
                            let patient = Patient(shortId: shortId)
                            PatientsViewModel(cloudFunctions: self.services.cloudFunctions!).confirmPatient(patient)
                        }
                    }
                }
            default:
                break
            }
        } else {
            if let vc = window?.rootViewController! {
                UIAlertController.showNoAction(on: vc, title: title, message: body)
            }
        }
    }
}

// MARK: TestDB Setup, onyl for TESTING
extension AppDelegate {
    
    private func testBundle() -> Bundle? {
        let all = Bundle.allBundles.filter { $0.bundlePath.hasSuffix("xctest") }
        let testBundle = all.isEmpty ? Bundle.main : all.first
        return testBundle
    }
    
    private func initTestDB() {
        let iniPath = testBundle()!.path(forResource: "TEST-GoogleService-Info", ofType: "plist")!
        FirebaseApp.configure(options: FirebaseOptions.init(contentsOfFile: iniPath)!)
        let dbURL = FirebaseApp.app()?.options.databaseURL ?? ""
        print("💊 DB URL -> \(dbURL)")
        if !dbURL.contains("localhost") {
            fatalError("!!! MUST BE ON A LOCAL DB !!!")
        }
    }
}

