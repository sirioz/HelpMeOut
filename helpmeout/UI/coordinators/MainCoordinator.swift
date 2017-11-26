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
    
    init(withWindow: UIWindow) {
        self.window = withWindow
    }
    
    func start() {
        
        let tab = UITabBarController()
        
        let homeVC = HomeViewController.instantiate()
        let caregiversVC = CaregiversViewController.instantiate()
        let notificationsVC = NotificationsViewController.instantiate()
        
        tab.viewControllers = [homeVC, caregiversVC, notificationsVC]
        window.rootViewController = tab
        
    }
    
}
