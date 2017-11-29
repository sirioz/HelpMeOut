//
//  HomeViewModel.swift
//  helpmeout
//
//  Created by Sirio Zuelli on 26/11/17.
//  Copyright © 2017 Sirio Zuelli. All rights reserved.
//

import Foundation
import When

struct HomeViewModel {
    let cloudFunctions: CloudFunctions
}

extension HomeViewModel {
    
    func shortId(onData: @escaping (ShortId?) -> Void) {
        guard let uid = cloudFunctions.currentUser?.uid else {
            onData(nil)
            return
        }
        cloudFunctions.userShortId(uid: uid, userType: .patient, onData: onData)
    }
    
    func fetchCaregivers(onData: @escaping ([Caregiver]) -> Void) {
        if let uid = self.cloudFunctions.currentUser?.uid {
            self.cloudFunctions.caregiversForPatient(patientUid: uid) { caregivers in
                onData(caregivers)
            }
        } else {
            onData([])
        }
    }
    
    func createSosRequest(onCompletion: @escaping (Error?) -> Void) {
        guard let uid = cloudFunctions.currentUser?.uid else {
            onCompletion(CloudError("Invalid patient UID"))
            return
        }
        cloudFunctions.createSosRequest(patientUid: uid, onCompletion: onCompletion)
    }
    
    func logout() {
        cloudFunctions.logout()
    }
}
