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
    weak var delegate: LoginDelegate?
    
    init(withWindow: UIWindow, delegate: LoginDelegate) {
        self.window = withWindow
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
        window.rootViewController = authViewController
                
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
