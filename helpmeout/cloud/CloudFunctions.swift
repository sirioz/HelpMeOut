//
//  CloudFunctions.swift
//  helpmeout
//
//  Created by Sirio Zuelli on 22/11/17.
//  Copyright © 2017 Sirio Zuelli. All rights reserved.
//

import Foundation
import When
import Firebase

protocol CloudFunctions: class {
    
    var currentUser: User? {get}
    
    func authWithPhone(_ phone: String) -> Promise<String?>
    func verifySMSCode(verificationID: String, verificationCode: String) -> Promise<User?>
    func createNewPatient() -> Promise<User>
    func createNewCaregiver() -> Promise<User>
    func setAPNS(_ token: String, userType: UserType, forUserId: String)
}
