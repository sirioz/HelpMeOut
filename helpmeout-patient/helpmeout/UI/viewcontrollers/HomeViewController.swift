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
    @IBOutlet weak var emptyStateLabel: UILabel!
    
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
        
        sosPanelView.isHidden = true
        emptyStateLabel.isHidden = true
        
        viewModel.shortId { [unowned self] shortId in
            let title = NSLocalizedString("Your ID", comment: "")
            self.titleLabel.text = "\(title)\n\(shortId ?? "")"
        }
        
        viewModel.fetchCaregivers { [unowned self] caregivers in
            let active = caregivers.filter { !$0.waiting }
            self.sosPanelView.isHidden = active.count == 0
            self.emptyStateLabel.isHidden = !self.sosPanelView.isHidden
        }
    }
}

extension HomeViewController {
    
    @IBAction func logoutPressed(_ sender: Any) {
        viewModel.logout()
        LoginCoordinator(withWindow: self.view.window!, cloudFunctions: viewModel.cloudFunctions).start()
    }
    
    @IBAction func sosButtonPressed(_ sender: UIButton) {
        sender.isEnabled = false
        viewModel.createSosRequest { error in
            sender.isEnabled = true
            if let error = error {
                Log.error(error)
                UIAlertController.showNoAction(on: self, title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("An error has occurred sending the SOS request.", comment: ""))
            } else {
                UIAlertController.showNoAction(on: self, title: NSLocalizedString("Request successful", comment: ""), message: NSLocalizedString("SOS request sent to your caregivers.", comment: ""))
            }
        }
    }

}
