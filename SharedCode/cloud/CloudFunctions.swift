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
    var isAuthenticated: Bool {get}
    
    func isCaregiverValid(_ shortId: ShortId, onCompletion: @escaping (Bool) -> Void)
    func userShortId(uid: String, userType: UserType) -> Promise<ShortId>
    func createNewUser(uid: String, userType: UserType) -> Promise<ShortId>
    func caregiversForPatient(patientUid: String, onData: @escaping ([Caregiver]) -> Void)
    func patientsForCaregiver(caregiverUid: String, onData: @escaping ([Patient]) -> Void)
    func confirmPatient(patientShortId: ShortId, to caregiverUid: String, onCompletion: @escaping (Error?) -> Void)
    func askForCaregiver(patientUid: String, caregiverShortId: ShortId, onCompletion: @escaping (Error?) -> Void)
    func createSosRequest(patientUid: String, onCompletion: @escaping (Error?) -> Void)
    func sosRequests(patientUid: String, onCompletion: @escaping ([SosRequest], Error?) -> Void)
    
    func logout()
    
    func setAPNS(_ token: String, userType: UserType, forUserId: String)
}
