//
//  CaregiversViewController.swift
//  helpmeout-patient
//
//  Created by Sirio Zuelli on 26/11/17.
//  Copyright © 2017 Sirio Zuelli. All rights reserved.
//

import UIKit

class CaregiversViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let caregiverCellId = "caregiverCell"
    
    var viewModel: CaregiversViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        initObservers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension CaregiversViewController {
    
    class func instantiate() -> CaregiversViewController {
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "CaregiversViewController") as! CaregiversViewController
        vc.tabBarItem = UITabBarItem(title: NSLocalizedString("Caregivers", comment: ""), image: #imageLiteral(resourceName: "caregivers").resizedImageWithinRect(CGSize(width: 30, height: 30)), selectedImage: nil)
        return vc
    }
}

extension CaregiversViewController {
    
    func configure() {
        title = NSLocalizedString("Your caregivers", comment: "")
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton
        
    }
    
    func initObservers() {
        viewModel.fetchCaregivers { [unowned self] caregivers in
            self.viewModel.caregivers = caregivers
            self.tableView.reloadData()
        }
    }
    
    @objc func addButtonPressed(sender: UIBarButtonItem) {
        UIAlertController.showWithTextField(on: self, title: NSLocalizedString("Add Caregiver", comment: ""), message: NSLocalizedString("Insert ID", comment: "")) { shortId in
            if !(shortId?.isEmpty ?? true) {
                self.viewModel.askForCaregiver(shortId!) { error in
                    if error != nil {
                        UIAlertController.showNoAction(on: self, title: NSLocalizedString("Error", comment: ""), message: NSLocalizedString("This caregiver does not exist.", comment: ""))
                    }
                }
            }
        }
    }
}

// MARK: TableView delegates
extension CaregiversViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.caregivers?.count ?? 0
    }
}

extension CaregiversViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: caregiverCellId) as! CaregiversTableViewCell
        if let caregiver = viewModel.caregivers?[indexPath.row] {
            let imgStatus = caregiver.waiting ? UIImage.circle(diameter: 25.0, color: UIColor.yellow) : UIImage.circle(diameter: 25.0, color: UIColor.green)
            cell.configure(title: caregiver.shortId, rightImage: imgStatus)
        }
        
        return cell
        
    }
    
}
