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
import RxSwift

class FirCloudFunctions: CloudFunctions {
    
    private let db: DatabaseReference
    private let auth: Auth
    
    init() {
        self.db = Database.database().reference()
        self.auth = Auth.auth()
    }
    
    init(withDb: DatabaseReference, auth: Auth) {
        self.db = withDb
        self.auth = auth
    }
    
    var currentUser: User? {
        return auth.currentUser
    }
    var isAuthenticated: Bool {
        return currentUser != nil
    }
    
    func isCaregiverValid(_ shortId: ShortId, onCompletion: @escaping (Bool) -> Void) {
        db.child("caregivers").queryOrdered(byChild: "shortId").queryEqual(toValue: shortId).observeSingleEvent(of: .value) { snapshot in
            onCompletion(snapshot.value != nil)
        }
    }
    
    func userShortId(uid: String, userType: UserType) -> Promise<ShortId> {
        let p = Promise<ShortId>()
        guard !uid.isEmpty else { p.reject(CloudError("Empty UID")); return p }
        let userPath = userType.dbPath()
        db.child("\(userPath)/\(uid)/shortId").observeSingleEvent(of: .value) { snapshot in
            if let shortId = snapshot.value as? String {
                p.resolve(shortId)
            } else {
                p.reject(CloudError("Undefined shortId"))
            }
        }
        return p
    }
    
    func createNewUser(uid: String, userType: UserType) -> Promise<ShortId> {
        let p = Promise<ShortId>()
        guard !uid.isEmpty else { p.reject(CloudError("Empty UID")); return p }
        let userPath = userType.dbPath()
        db.child("\(userPath)/\(uid)").observeSingleEvent(of: .value) { [unowned self] snapshot in
            if snapshot.value == nil { // Create a new user
                Log.debug("New user")
                self.db.child("\(userPath)/\(uid)/shortId").setValue("") { [unowned self] error, ref in
                    if let error = error {
                        p.reject(error)
                    } else {
                        self.userShortId(uid: uid, userType: userType).then({ shortId in
                            p.resolve(shortId)
                        })
                    }
                }
            } else { // Existing user
                Log.debug("Existing user")
                self.userShortId(uid: uid, userType: userType).then({ shortId in
                    p.resolve(shortId)
                })
            }
        }
        
        return p
    }
    
    func caregiversForPatient(patientUid: String, onData:@escaping ([Caregiver]) -> Void) {
        
        db.child("/patients/\(patientUid)/caregivers").observe(.value) { snapshot in
            if let items = snapshot.children.allObjects as? [DataSnapshot] {
                let caregivers: [Caregiver] = items.flatMap {
                    let shortId = $0.key
                    guard let value = $0.value as? [String: Any] else { return nil }
                    return Caregiver(shortId: shortId, waiting: value["waiting"] as! Bool)
                }
                onData(caregivers)
            } else {
                onData([])
            }
        }
    }
    
    func askForCaregiver(patientUid: String, caregiverShortId: ShortId, onCompletion:@escaping (Error?) -> ()) {
        db.child("/patients/\(patientUid)/caregivers/\(caregiverShortId)/waiting").setValue(true) { error, _ in
            if let error = error {
                onCompletion(error)
            } else {
                onCompletion(nil)
            }
        }
    }

    func setAPNS(_ token: String, userType: UserType, forUserId: String) {
        guard !token.isEmpty else { return }
        guard !forUserId.isEmpty else { return }
        let userPath = userType.dbPath()
        db.child("\(userPath)/\(forUserId)/pushToken").setValue(token)
    }
    
    func logout() {
        try? auth.signOut()
    }
    
}

// MARK: Private methods
extension FirCloudFunctions {
    
    
}
