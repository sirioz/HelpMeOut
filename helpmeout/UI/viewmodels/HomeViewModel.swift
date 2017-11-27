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
    
    func shortId() -> Promise<ShortId> {
        guard let uid = cloudFunctions.currentUser?.uid else {
            let p = Promise<ShortId>()
            p.reject(CloudError("Invalid shortId"))
            return p
        }
        return cloudFunctions.userShortId(uid: uid, userType: .patient)
    }
    
    func logout() {
        cloudFunctions.logout()
    }
}
