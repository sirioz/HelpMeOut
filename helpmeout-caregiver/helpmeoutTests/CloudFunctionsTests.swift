//
//  helpmeoutTests.swift
//  helpmeoutTests
//
//  Created by Sirio Zuelli on 21/11/17.
//  Copyright © 2017 Sirio Zuelli. All rights reserved.
//

import XCTest
@testable import helpmeout_caregiver
import Firebase

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
            db.child(path("caregivers/1234567890/shortId")).setValue("abc") { error, _ in
                XCTAssertNil(error)
                self.sut.isCaregiverValid("abc") { isValid in
                    XCTAssertTrue(isValid)
                    e.fulfill()
                }
            }
        }
    }
    
    func test_userShortId() {
        syncWait(2.0) { [unowned self] e in
            db.child(path("caregivers/1234567890/shortId")).setValue("abc") { [unowned self] error, _ in
                XCTAssertNil(error)
                self.sut.userShortId(uid: "1234567890", userType: .caregiver) { (shortId) in
                    XCTAssertEqual(shortId, "abc")
                    e.fulfill()
                }
            }
        }
    }
}
