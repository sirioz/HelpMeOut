//
//  MainCoordinator.swift
//  helpmeout
//
//  Created by Sirio Zuelli on 26/11/17.
//  Copyright © 2017 Sirio Zuelli. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    
    let window: UIWindow
    let cloudFunctions: CloudFunctions
    var notificationHelper: NotificationHelper?
    
    init(withWindow: UIWindow, cloudFunctions: CloudFunctions) {
        self.window = withWindow
        self.cloudFunctions = cloudFunctions
    }
    
    func start() {
        
        let tab = UITabBarController()
        tab.tabBar.tintColor = UIColor.red
        tab.tabBar.unselectedItemTintColor = UIColor.black
        tab.tabBar.barTintColor = UIColor.white
        
        let homeVC = HomeViewController.instantiate()
        homeVC.viewModel = HomeViewModel(cloudFunctions: cloudFunctions)
        
        let patientsVC = PatientsViewController.instantiate()
        patientsVC.viewModel = PatientsViewModel(cloudFunctions: cloudFunctions)
        let patientsNav = UINavigationController(rootViewController: patientsVC)

        let notificationsVC = NotificationsViewController.instantiate()
        notificationsVC.viewModel = NotificationsViewModel(cloudFunctions: cloudFunctions)
        let notificationsNav = UINavigationController(rootViewController: notificationsVC)
        
        tab.viewControllers = [patientsNav, homeVC, notificationsNav]
        window.rootViewController = tab
        tab.selectedIndex = 1
        
        notificationHelper = NotificationHelper(application: UIApplication.shared, cloudFunctions: cloudFunctions)
        notificationHelper?.sendCurrentUserFCMToken()
        notificationHelper?.setupRemoteNotifications()
        
    }
    
}
