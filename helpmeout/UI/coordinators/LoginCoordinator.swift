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

class LoginCoordinator: NSObject, Coordinator {
    
    let window: UIWindow
    
    init(withWindow: UIWindow) {
        self.window = withWindow
    }
    
    func start() {
        
        let authUI = FUIAuth.defaultAuthUI()!
        authUI.delegate = self
        let providers: [FUIAuthProvider] = [
            FUIPhoneAuth(authUI:authUI),
        ]
        authUI.providers = providers
        let authViewController = authUI.authViewController()
        window.rootViewController = authViewController
                
    }
    
}

extension FUIAuthBaseViewController{
    open override func viewWillAppear(_ animated: Bool) {
        self.title = NSLocalizedString("Patient", comment: "")
        self.navigationItem.leftBarButtonItem = nil
    }
}

extension LoginCoordinator: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        MainCoordinator(withWindow: window).start()
    }
    
}
