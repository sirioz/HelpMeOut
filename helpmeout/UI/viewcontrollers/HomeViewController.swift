//
//  HomeViewController.swift
//  helpmeout
//
//  Created by Sirio Zuelli on 26/11/17.
//  Copyright © 2017 Sirio Zuelli. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HomeViewController {
    
    class func instantiate() -> HomeViewController {
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        vc.tabBarItem = UITabBarItem(title: NSLocalizedString("Home", comment: ""), image: nil, selectedImage: nil)
        return vc
    }
}
