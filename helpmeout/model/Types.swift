//
//  Types.swift
//  helpmeout
//
//  Created by Sirio Zuelli on 25/11/17.
//  Copyright © 2017 Sirio Zuelli. All rights reserved.
//

import Foundation

enum UserType {
    case patient
    case caregiver
}

extension UserType {
    func dbPath() -> String {
        switch self {
        case .patient:
            return "patients"
        case .caregiver:
            return "caregivers"
        }
    }
}

enum CloudError: Error, CustomStringConvertible {

    case message(String)
    case generic(Error)
    
    var description: String {
        switch self {
        case .message(let msg):
            return msg
        case .generic(let error):
            return (error as NSError).localizedDescription
        }
    }
    
    init(_ message: String) {
        self = .message(message)
    }
    
}

