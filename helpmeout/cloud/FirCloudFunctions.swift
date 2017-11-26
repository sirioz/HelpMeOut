//
//  FirCloudFunctions.swift
//  helpmeout
//
//  Created by Sirio Zuelli on 22/11/17.
//  Copyright © 2017 Sirio Zuelli. All rights reserved.
//

import Foundation
import Firebase
import When

class FirCloudFunctions: CloudFunctions {
    
    private let db = Database.database().reference()
    
    var currentUser: User? {
        return Auth.auth().currentUser
    }
    
    func authWithPhone(_ phone: String) -> Promise<String?> {
        let p = Promise<String?>()
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { (verificationID, error) in
            if let error = error {
                p.reject(error)
            } else {
                p.resolve(verificationID)
            }
        }
        return p
    }
    
    func verifySMSCode(verificationID: String, verificationCode: String) -> Promise<User?> {
        let p = Promise<User?>()
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if let error = error {
                p.reject(error)
            } else {
                p.resolve(user)
            }
        }
        
        return p
    }
    
    func createNewPatient() -> Promise<User> {
        let p = Promise<User>()
        
        return p
    }
    
    func createNewCaregiver() -> Promise<User> {
        let p = Promise<User>()
        
        return p
    }
    
    func setAPNS(_ token: String, userType: UserType, forUserId: String) {
        guard token.count > 0 else { return }
        guard forUserId.count > 0 else { return }
        let userPath = userType.dbPath()
        db.child(userPath).child(forUserId).updateChildValues(["pushToken": token])
    }
    
}
