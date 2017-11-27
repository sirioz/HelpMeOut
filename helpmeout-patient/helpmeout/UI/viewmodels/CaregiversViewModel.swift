//
//  CaregiversViewModel.swift
//  helpmeout
//
//  Created by Sirio Zuelli on 26/11/17.
//  Copyright © 2017 Sirio Zuelli. All rights reserved.
//

import Foundation

struct CaregiversViewModel {
    
    let cloudFunctions: CloudFunctions
    var caregivers: [Caregiver]?
    
    init(cloudFunctions: CloudFunctions) {
        self.cloudFunctions = cloudFunctions
    }
}

extension CaregiversViewModel {
    
    func fetchCaregivers(onData: @escaping ([Caregiver]) -> Void) {
        if let uid = self.cloudFunctions.currentUser?.uid {
            self.cloudFunctions.caregiversForPatient(patientUid: uid) { caregivers in
                onData(caregivers)
            }
        } else {
            onData([])
        }
    }
    
    func askForCaregiver(_ shortId: ShortId, onCompletion: @escaping (Error?) -> Void) {
        self.cloudFunctions.isCaregiverValid(shortId) { isValid in
            guard isValid else {
                onCompletion(CloudError("Caregiver does not exist."))
                return
            }
            if let uid = self.cloudFunctions.currentUser?.uid {
                self.cloudFunctions.askForCaregiver(patientUid: uid, caregiverShortId: shortId, onCompletion: onCompletion)
            } else {
                onCompletion(CloudError("Invalid UID"))
            }
        }
    }
        
}
