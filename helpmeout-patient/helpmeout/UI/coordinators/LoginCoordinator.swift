//
//  LoginCoordinator.swift
//  helpmeout
//
//  Created by Sirio Zuelli on 25/11/17.
//  Copyright © 2017 Sirio Zuelli. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuthUI
import FirebasePhoneAuthUI

protocol LoginDelegate: class {
    func didSignInWith(user: User?, error: Error?)
}

class LoginCoordinator: NSObject, Coordinator {
    
    let window: UIWindow
    let cloudFunctions: CloudFunctions
    weak var delegate: LoginDelegate?
    
    init(withWindow: UIWindow, cloudFunctions: CloudFunctions, delegate: LoginDelegate? = nil) {
        self.window = withWindow
        self.cloudFunctions = cloudFunctions
        self.delegate = delegate
    }
    
    func start() {
        
        let authUI = FUIAuth.defaultAuthUI()!
        authUI.delegate = self
        let providers: [FUIAuthProvider] = [
            FUIPhoneAuth(authUI: authUI)
        ]
        authUI.providers = providers
        let authViewController = authUI.authViewController()
        
        if self.delegate == nil {
            self.delegate = self
        }
        
        window.rootViewController?.present(authViewController, animated: false, completion: nil)
                
    }
    
}

extension FUIAuthBaseViewController {
    open override func viewWillAppear(_ animated: Bool) {
        self.title = NSLocalizedString("Patient", comment: "")
        self.navigationItem.leftBarButtonItem = nil
    }
}

extension LoginCoordinator: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        self.delegate?.didSignInWith(user: user, error: error)
    }
}

// MARK: Login delegate
extension LoginCoordinator: LoginDelegate {
    
    func didSignInWith(user: User?, error: Error?) {
        if let error = error {
            Log.error(error)
            return
        }
        
        if let user = user {
            cloudFunctions.createNewUser(uid: user.uid, userType: Constants.userType).done({ [unowned self] _ in
                MainCoordinator(withWindow: self.window, cloudFunctions: self.cloudFunctions).start()
            })
        }
    }
}
