//
//  Logger.swift
//

import Foundation

protocol Logger {
    
    static func info(_ message: CustomStringConvertible, function: String)
    static func success(_ message: CustomStringConvertible, function: String)
    static func debug(_ message: CustomStringConvertible, function: String)
    static func warning(_ message: CustomStringConvertible, function: String)
    static func error(_ error: Error?, message: String?, function: String)
    
}
