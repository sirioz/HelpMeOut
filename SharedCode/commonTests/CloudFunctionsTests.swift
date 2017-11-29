//
//  helpmeoutTests.swift
//  helpmeoutTests
//
//  Created by Sirio Zuelli on 21/11/17.
//  Copyright © 2017 Sirio Zuelli. All rights reserved.
//

import XCTest
@testable import helpmeout
import Firebase
import When

// IMPORTANT:
// TESTS ARE DONE ON A LOCAL FIREBASE SERVER
// Reference: https://firebase.googleblog.com/2015/04/end-to-end-testing-with-firebase-server_16.html

class CloudFunctionsTests: XCTestCase {
    
    let root = "/"
    
    var db: DatabaseReference!
    var sut: CloudFunctions!
    
    override func setUp() {
        super.setUp()
        self.db = Database.database().reference()
        sut = FirCloudFunctions(withDb: db, auth: nil)
    }
    
    override func tearDown() {
        super.tearDown()
        cleanUp()
    }
    
}

// MARK: Helpers
extension CloudFunctionsTests {
    
    private func valueAtPath(_ path: String, onData: @escaping (Any?) -> Void) {
        db.child(path).observeSingleEvent(of: .value) { snapshot in
            onData(snapshot.value)
        }
    }
    
    private func path(_ p: String) -> String {
        return "\(root)/\(p)"
    }
    
    private func cleanUp() {
        // Wait a bit before to cleanup the db, because some operations could be still in progress
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.db.child(self.root).removeValue()
        }
    }
    
    private func loadJson(_ name: String, onCompletion: @escaping (Error?) -> Void) {
        let json = try! MockHelper.readData(name)!
        let jDic = try! JSONSerialization.jsonObject(with: json, options: []) as? [String: Any]
        db.setValue(jDic) { error, _ in
            onCompletion(error)
        }
    }
    
    private func syncWait(_ sec: TimeInterval, block: (XCTestExpectation) -> Void) {
        let e = expectation(description: "")
        block(e)
        waitForExpectations(timeout: sec)
    }
    
}

// MARK: CloudFunctions tests
extension CloudFunctionsTests {
    
    func test_isCaregiverValid() {
        syncWait(2.0) { [unowned self] e in
            loadJson("simple.json") { error in
                XCTAssertNil(error)
                self.sut.isCaregiverValid("SknaJNilG") { isValid in
                    XCTAssertTrue(isValid)
                    e.fulfill()
                }
            }
        }
    }
    
    func test_isCaregiverNOTValid() {
        syncWait(2.0) { [unowned self] e in
            loadJson("simple.json") { error in
                XCTAssertNil(error)
                self.sut.isCaregiverValid("INVALID") { isValid in
                    XCTAssertFalse(isValid)
                    e.fulfill()
                }
            }
        }
    }
    
    func test_userShortId() {
        syncWait(2.0) { [unowned self] e in
            loadJson("simple.json") { error in
                XCTAssertNil(error)
                self.sut.userShortId(uid: "7CcpEAgJUuaB6LTJGDWm0HX6wUO2", userType: .caregiver) { shortId in
                    XCTAssertEqual(shortId, "SknaJNilG")
                    e.fulfill()
                }
            }
        }
    }
    
    // Creating a new user on production rely on some triggers
    // In local we just test if an already existing user is returned
    func test_createNewUser() {
        syncWait(2.0) { [unowned self] e in
            loadJson("simple.json") { error in
                XCTAssertNil(error)
                self.sut.createNewUser(uid: "7CcpEAgJUuaB6LTJGDWm0HX6wUO2", userType: .caregiver).done { shortId in
                    XCTAssertEqual(shortId, "SknaJNilG")
                    e.fulfill()
                }
            }
        }
    }
    
    func test_caregiversForPatient() {
        syncWait(2.0) { [unowned self] e in
            loadJson("simple.json") { error in
                XCTAssertNil(error)
                self.sut.caregiversForPatient(patientUid: "4uv5FbamwXb3tihe4iSTw9EtKLk2") { caregivers in
                    XCTAssertEqual(caregivers.count, 1)
                    XCTAssertEqual(caregivers[0].shortId, "SknaJNilG")
                    XCTAssertEqual(caregivers[0].waiting, false)
                    e.fulfill()
                }
            }
        }
    }
}
