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
        
        let caregiversVC = CaregiversViewController.instantiate()
        caregiversVC.viewModel = CaregiversViewModel(cloudFunctions: cloudFunctions)
        let caregiversNav = UINavigationController(rootViewController: caregiversVC)
        
        let notificationsVC = NotificationsViewController.instantiate()
        notificationsVC.viewModel = NotificationsViewModel(cloudFunctions: cloudFunctions)
        let notificationsNav = UINavigationController(rootViewController: notificationsVC)
        
        tab.viewControllers = [caregiversNav, homeVC, notificationsNav]
        window.rootViewController = tab
        tab.selectedIndex = 1
        
    }
    
}
