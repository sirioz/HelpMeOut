//
//  NotificationsViewModel.swift
//  helpmeout-patient
//
//  Created by Sirio Zuelli on 27/11/17.
//  Copyright © 2017 Sirio Zuelli. All rights reserved.
//

import Foundation

struct NotificationsViewModel {
    
    let cloudFunctions: CloudFunctions
    var sosRequests: [SosRequest]?
    
    init(cloudFunctions: CloudFunctions) {
        self.cloudFunctions = cloudFunctions
    }
}

extension NotificationsViewModel {
    
    func fetchSosRequests(onData: @escaping ([SosRequest]) -> Void) {
        if let uid = self.cloudFunctions.currentUser?.uid {
            self.cloudFunctions.sosRequests(patientUid: uid) { sosRequests, error in
                if let error = error {
                    Log.error(error)
                    onData([])
                } else {
                    onData(sosRequests)
                }
            }
        } else {
            onData([])
        }
    }
}
