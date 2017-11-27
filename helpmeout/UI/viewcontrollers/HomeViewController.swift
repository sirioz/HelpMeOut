//
//  HomeViewController.swift
//  helpmeout
//
//  Created by Sirio Zuelli on 26/11/17.
//  Copyright © 2017 Sirio Zuelli. All rights reserved.
//

import UIKit

class HomeViewController: BaseViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var sosPanelView: UIView!
    
    var viewModel: HomeViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension HomeViewController {
    
    class func instantiate() -> HomeViewController {
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        vc.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "sos").resizedImageWithinRect(CGSize(width: 40, height: 40)), selectedImage: nil)
        return vc
    }
}

extension HomeViewController {
    
    private func configure() {
        viewModel.shortId().done { [unowned self] shortId in
            let title = NSLocalizedString("Your ID", comment: "")
            self.titleLabel.text = "\(title)\n\(shortId)"
        }
    }
}

extension HomeViewController {
    
    @IBAction func logoutPressed(_ sender: Any) {
        viewModel.logout()
    }
    
    @IBAction func sosButtonPressed(_ sender: Any) {
    }

}
