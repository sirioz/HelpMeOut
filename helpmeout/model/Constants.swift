//
//  Constants.swift
//  helpmeout
//
//  Created by Sirio Zuelli on 25/11/17.
//  Copyright © 2017 Sirio Zuelli. All rights reserved.
//

import Foundation

struct Constants {

        #if PATIENT
            static let userType = UserType.patient
        #else
            static let userType = UserType.caregiver
        #endif
}
