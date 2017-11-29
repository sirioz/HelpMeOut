//
//  CaregiversViewModel.swift
//  helpmeout
//
//  Created by Sirio Zuelli on 26/11/17.
//  Copyright © 2017 Sirio Zuelli. All rights reserved.
//

import Foundation

struct PatientsViewModel {
    
    let cloudFunctions: CloudFunctions
    var patients: [Patient]?
    
    init(cloudFunctions: CloudFunctions) {
        self.cloudFunctions = cloudFunctions
    }
}

extension PatientsViewModel {
    
    func fetchPatients(onData: @escaping ([Patient]) -> Void) {
        if let uid = self.cloudFunctions.currentUser?.uid {
            cloudFunctions.patientsForCaregiver(caregiverUid: uid) { patients in
                onData(patients)
            }
        } else {
            onData([])
        }
    }
    
    func confirmPatient(_ patient: Patient) {
        if let uid = self.cloudFunctions.currentUser?.uid {
            cloudFunctions.confirmPatient(patientShortId: patient.shortId, to: uid) { error in
                if let error = error {
                    Log.error(error)
                }
            }
        }
    }
    
}
