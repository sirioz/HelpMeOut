//
//  CaregiversViewController.swift
//  helpmeout-patient
//
//  Created by Sirio Zuelli on 26/11/17.
//  Copyright © 2017 Sirio Zuelli. All rights reserved.
//

import UIKit

class PatientsViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let cellId = "patientCell"
    
    var viewModel: PatientsViewModel!
    
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

extension PatientsViewController {
    
    class func instantiate() -> PatientsViewController {
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "PatientsViewController") as! PatientsViewController
        vc.tabBarItem = UITabBarItem(title: NSLocalizedString("Patients", comment: ""), image: #imageLiteral(resourceName: "patients").resizedImageWithinRect(CGSize(width: 30, height: 30)), selectedImage: nil)
        return vc
    }
}

extension PatientsViewController {
    
    private func configure() {
        title = NSLocalizedString("Your Patients", comment: "")
    }
    
    private func initObservers() {
        viewModel.fetchPatients { [unowned self] patients in
            self.viewModel.patients = patients
            self.tableView.reloadData()
        }
    }
    
    fileprivate func confirmPatient(_ patient: Patient) {
        UIAlertController.showConfirm(on: self, title: NSLocalizedString("Confirm Patient", comment: ""), message: NSLocalizedString("Do you confirm to accept patient '\(patient.shortId)'?", comment: "")) {
            self.viewModel.confirmPatient(patient)
        }
    }
    
}

// MARK: TableView delegates
extension PatientsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.patients?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let patient = (tableView.cellForRow(at: indexPath) as? PatientsTableViewCell)?.patient {
            if patient.waiting {
                confirmPatient(patient)
            }
        }
    }
}

extension PatientsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! PatientsTableViewCell
        if let patient = viewModel.patients?[indexPath.row] {
            cell.configure(with: patient)
        }
        
        return cell
        
    }
    
}
