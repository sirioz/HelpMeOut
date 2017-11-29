//
//  MockHelper.swift

import Foundation

class MockHelper {
    
    static func readJson(_ name: String) throws -> String? {
        if let data = try self.readData(name) {
            return String(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }

    static func readData(_ name: String) throws -> Data? {
        
        let all = Bundle.allBundles.filter { $0.bundlePath.hasSuffix("xctest") }
        let testBundle = all.isEmpty ? Bundle.main : all.first!
        if let path = testBundle.path(forResource: name, ofType: nil) {
            return try Data(contentsOf: URL(fileURLWithPath: path))
        } else {
            return nil
        }
    }
}
