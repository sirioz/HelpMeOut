//
//  NotificationsViewController.swift
//  helpmeout-patient
//
//  Created by Sirio Zuelli on 26/11/17.
//  Copyright © 2017 Sirio Zuelli. All rights reserved.
//

import UIKit

class NotificationsViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension NotificationsViewController {
    
    class func instantiate() -> NotificationsViewController {
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController
        vc.tabBarItem = UITabBarItem(title: NSLocalizedString("Notifications", comment: ""), image: #imageLiteral(resourceName: "notifications").resizedImageWithinRect(CGSize(width: 30, height: 30)), selectedImage: nil)
        return vc
    }
}
