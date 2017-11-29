//
//  NotificationsViewController.swift
//  helpmeout-patient
//
//  Created by Sirio Zuelli on 26/11/17.
//  Copyright © 2017 Sirio Zuelli. All rights reserved.
//

import UIKit

class NotificationsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let cellId = "notificationCell"
    
    var viewModel: NotificationsViewModel!
    
    lazy var tsFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .short
        df.timeStyle = .short
        return df
    }()
    
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

extension NotificationsViewController {
    
    class func instantiate() -> NotificationsViewController {
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: "NotificationsViewController") as! NotificationsViewController
        vc.tabBarItem = UITabBarItem(title: NSLocalizedString("Notifications", comment: ""), image: #imageLiteral(resourceName: "notifications").resizedImageWithinRect(CGSize(width: 30, height: 30)), selectedImage: nil)
        return vc
    }
}

extension NotificationsViewController {
    
    func configure() {
        title = NSLocalizedString("Notifications", comment: "")
    }
    
    func initObservers() {
        viewModel.fetchSosRequests { [unowned self] sosRequests in
            self.viewModel.sosRequests = sosRequests
            self.tableView.reloadData()
        }
    }
}

// MARK: TableView delegates
extension NotificationsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.sosRequests?.count ?? 0
    }
}

extension NotificationsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) ?? UITableViewCell()
        if let sosRequest = viewModel.sosRequests?[indexPath.row] {
            cell.textLabel?.text = NSLocalizedString("Sos request", comment: "")
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14.0)
            cell.detailTextLabel?.textColor = UIColor.gray
            cell.detailTextLabel?.text = tsFormatter.string(from: sosRequest.date)
        }
        
        return cell
        
    }
        
}
