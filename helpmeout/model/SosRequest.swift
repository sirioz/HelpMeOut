//
//  SosRequest.swift
//  helpmeout-patient
//
//  Created by Sirio Zuelli on 27/11/17.
//  Copyright © 2017 Sirio Zuelli. All rights reserved.
//

import Foundation

struct SosRequest {
    let timeStamp: Date
    let caregiversShortId: [ShortId]
    
    init(unixTs: TimeInterval, caregiversShortId: [ShortId]) {
        self.timeStamp = Date(timeIntervalSince1970: unixTs / 1000)
        self.caregiversShortId = caregiversShortId
    }
}


