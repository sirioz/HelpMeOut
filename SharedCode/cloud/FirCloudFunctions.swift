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

final class FirCloudFunctions: CloudFunctions {

    private let db: DatabaseReference
    private let auth: Auth
    
    init() {
        self.db = Database.database().reference()
        self.auth = Auth.auth()
    }
    
    init(withDb: DatabaseReference, auth: Auth?) {
        self.db = withDb
        self.auth = auth ?? Auth.auth()
    }
    
    var currentUser: User? {
        return auth.currentUser
    }
    var isAuthenticated: Bool {
        return currentUser != nil
    }
    
    func isCaregiverValid(_ shortId: ShortId, onCompletion: @escaping (Bool) -> Void) {
        db.child("caregivers").queryOrdered(byChild: "shortId").queryEqual(toValue: shortId).observeSingleEvent(of: .value) { snapshot in
            onCompletion(snapshot.exists())
        }
    }
    
    func userShortId(uid: String, userType: UserType, onData: @escaping (ShortId?) -> Void) {
        guard !uid.isEmpty else { onData(nil); return }
        let userPath = userType.dbPath()
        db.child("\(userPath)/\(uid)/shortId").observe(.value) { snapshot in
            let shortId = snapshot.value as? String
            onData(shortId)
        }
    }
    
    func userShortId(uid: String, userType: UserType) -> Promise<ShortId> {
        let p = Promise<ShortId>()
        guard !uid.isEmpty else { p.reject(CloudError("Empty UID")); return p }
        userShortId(uid: uid, userType: userType) { shortId in
            if let shortId = shortId {
                p.resolve(shortId)
            } else {
                p.reject(CloudError("Undefined ShortId"))
            }
        }
        return p
    }
    
    private func userId(fromShortId: ShortId, userType: UserType) -> Promise<String> {
        let p = Promise<String>()
        let userPath = userType.dbPath()
        db.child("\(userPath)").queryOrdered(byChild: "shortId").queryEqual(toValue: fromShortId).observeSingleEvent(of: .value) { snapshot in
            if let uid = (snapshot.children.allObjects[0] as? DataSnapshot)?.key {
                p.resolve(uid)
            } else {
                p.reject(CloudError("Undefined UID"))
            }
        }
        return p
    }
    
    func createNewUser(uid: String, userType: UserType) -> Promise<ShortId> {
        let p = Promise<ShortId>()
        guard !uid.isEmpty else { p.reject(CloudError("Empty UID")); return p }
        let userPath = userType.dbPath()
        db.child("\(userPath)/\(uid)").observeSingleEvent(of: .value) { [unowned self] snapshot in
            if !snapshot.hasChildren() { // Create a new user
                Log.debug("New user")
                self.db.child("\(userPath)/\(uid)/shortId").setValue("") { [unowned self] error, _ in
                    if let error = error {
                        p.reject(error)
                    } else {
                        self.userShortId(uid: uid, userType: userType) { shortId in
                            p.resolve(shortId ?? "")
                        }
                    }
                }
            } else { // Existing user
                Log.debug("Existing user")
                self.userShortId(uid: uid, userType: userType) { shortId in
                    p.resolve(shortId ?? "")
                }
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
    
    func patientsForCaregiver(caregiverUid: String, onData: @escaping ([Patient]) -> Void) {
        db.child("/caregivers/\(caregiverUid)/patients").observe(.value) { snapshot in
            if let items = snapshot.children.allObjects as? [DataSnapshot] {
                let patients: [Patient] = items.flatMap {
                    let shortId = $0.key
                    guard let value = $0.value as? [String: Any] else { return nil }
                    return Patient(shortId: shortId, waiting: value["waiting"] as! Bool)
                }
                onData(patients)
            } else {
                onData([])
            }
        }
    }
    
    func confirmPatient(patientShortId: ShortId, to caregiverUid: String, onCompletion: @escaping (Error?) -> Void) {
        db.child("/caregivers/\(caregiverUid)/patients/\(patientShortId)/waiting").setValue(false) { [unowned self] error, _ in
            if let error = error {
                onCompletion(error)
                return
            }
            when(self.userId(fromShortId: patientShortId, userType: .patient),
                 self.userShortId(uid: caregiverUid, userType: .caregiver)
                ).done{ patientUid, caregiverShortId in
                    self.db.child("/patients/\(patientUid)/caregivers/\(caregiverShortId)/waiting").setValue(false) { error, _ in
                        onCompletion(error)
                    }
            }
        }
    }
    
    func askForCaregiver(patientUid: String, caregiverShortId: ShortId, onCompletion:@escaping (Error?) -> Void) {
        db.child("/patients/\(patientUid)/caregivers/\(caregiverShortId)/waiting").setValue(true) { [unowned self] error, _ in
            if let error = error {
                onCompletion(error)
                return
            }
            when(self.userId(fromShortId: caregiverShortId, userType: .caregiver),
                 self.userShortId(uid: patientUid, userType: .patient)
                ).done{ caregiverUid, patientShortId in
                    self.db.child("/caregivers/\(caregiverUid)/patients/\(patientShortId)/waiting").setValue(true) { error, _ in
                        onCompletion(error)
                    }
            }
        }
    }
    
    func createSosRequest(patientUid: String, onCompletion: @escaping (Error?) -> Void) {
        
        // Setting a 0 value gives me a completion block to know when the request completed
        db.child("/patients/\(patientUid)/sosRequests").childByAutoId().child("timeStamp").setValue(0) { error, _ in
            if let error = error {
                onCompletion(error)
            } else {
                onCompletion(nil)
            }
        }
    }
    
    func sosRequests(uId: String, userType: UserType, onCompletion: @escaping ([SosRequest], Error?) -> Void) {
        let userPath = userType.dbPath()
        db.child("\(userPath)/\(uId)/sosRequests").observe(.value) { snapshot in
            if let items = snapshot.children.allObjects as? [DataSnapshot] {
                let sosRequests: [SosRequest] = items.flatMap {
                    guard let value = $0.value as? [String: Any] else { return nil }
                    guard let ts = value["timeStamp"] as? TimeInterval else { return nil }
                    let shortId = value["shortId"] as? ShortId
                    return SosRequest(unixTs: ts, shortId: shortId)
                }
                onCompletion(sosRequests, nil)
            } else {
                onCompletion([], CloudError("Fetched invalid sos requests"))
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
        
        // TODO: unsubscribe from notifications
    }
    
}


