//
//  HomeViewModel.swift
//  helpmeout
//
//  Created by Sirio Zuelli on 26/11/17.
//  Copyright © 2017 Sirio Zuelli. All rights reserved.
//

import Foundation

struct HomeViewModel {
    let cloudFunctions: CloudFunctions
}

extension HomeViewModel {
    
    func shortId(onData: @escaping (ShortId?) -> Void) {
        guard let uid = cloudFunctions.currentUser?.uid else {
            onData(nil)
            return
        }
        cloudFunctions.userShortId(uid: uid, userType: .caregiver, onData: onData)
    }
    
    func logout() {
        cloudFunctions.logout()
    }
}
