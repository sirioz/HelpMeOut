//
//  SosRequest.swift
//  helpmeout-patient
//
//  Created by Sirio Zuelli on 27/11/17.
//  Copyright © 2017 Sirio Zuelli. All rights reserved.
//

import Foundation

struct SosRequest {
    let date: Date
    var shortId: ShortId?
    
    init(unixTs: TimeInterval, shortId: ShortId? = nil) {
        self.date = Date(timeIntervalSince1970: unixTs / 1000)
        self.shortId = shortId
    }
}
