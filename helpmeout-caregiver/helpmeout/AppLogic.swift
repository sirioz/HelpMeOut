//
//  AppLogic.swift
//  helpmeout
//
//  Created by Sirio Zuelli on 29/11/17.
//  Copyright © 2017 Sirio Zuelli. All rights reserved.
//

import Foundation
import UIKit

class AppLogic {
    
    let window: UIWindow
    let cloudFunctions: CloudFunctions
    
    init(window: UIWindow, cloudFunctions: CloudFunctions) {
        self.window = window
        self.cloudFunctions = cloudFunctions
    }
}

extension AppLogic: NotificationDelegate {
    
    func didReceivePushData(userInfo: NSDictionary?, title: String?, body: String?) {
        
        if let opType = userInfo?["opType"] as? String {
            switch opType {
            case "pReq":
                if let vc = window.rootViewController {
                    UIAlertController.showConfirm(on: vc, title: title ?? "", message: body ?? "", actionTitle: NSLocalizedString("Confirm", comment: ""), actionStyle: .default, cancelActionTitle: NSLocalizedString("Cancel", comment: "")) { [unowned self] in
                        if let shortId = userInfo?["patientShortId"] as? String {
                            let patient = Patient(shortId: shortId)
                            PatientsViewModel(cloudFunctions: self.cloudFunctions).confirmPatient(patient)
                        }
                    }
                }
            default:
                break
            }
        } else {
            if let vc = window.rootViewController {
                UIAlertController.showNoAction(on: vc, title: title, message: body)
            }
        }
    }
    
}
