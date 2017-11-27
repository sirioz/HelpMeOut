//
//  ConsoleLogger.swift
//
//

import Foundation

class ConsoleLogger: Logger {
    static func info(_ message: CustomStringConvertible, function: String = #function) {
        print("ℹ️ \(function) \(message)")
    }
    
    static func success(_ message: CustomStringConvertible, function: String = #function) {
        print("✅ \(function) \(message)")
    }
    
    static func debug(_ message: CustomStringConvertible, function: String = #function) {
        #if DEBUG
        print("🚀 \(function) \(message)")
        #endif
    }
    
    static func warning(_ message: CustomStringConvertible, function: String = #function) {
        print("⚠️ \(function) \(message)")
    }

    static func error(_ error: Error?, message: String? = nil, function: String = #function) {
        if let error = error {
            print("❌ \(function) \(message ?? "") \(error)")
        } else {
            print("❌ \(function) \(message ?? "")")
        }
    }
}
