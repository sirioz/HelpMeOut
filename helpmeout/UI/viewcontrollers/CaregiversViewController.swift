//
//  CaregiversViewController.swift
//  helpmeout-patient
//
//  Created by Sirio Zuelli on 26/11/17.
//  Copyright © 2017 Sirio Zuelli. All rights reserved.
//

import UIKit

class CaregiversViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension CaregiversViewController {
    
    class func instantiate() -> CaregiversViewController {
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "CaregiversViewController") as! CaregiversViewController
        vc.tabBarItem = UITabBarItem(title: NSLocalizedString("Caregivers", comment: ""), image: nil, selectedImage: nil)
        return vc
    }
}
