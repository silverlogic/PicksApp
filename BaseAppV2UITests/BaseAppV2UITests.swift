//
//  BaseAppV2UITests.swift
//  BaseAppV2UITests
//
//  Created by Emanuel  Guerrero on 2/28/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
import OHHTTPStubs

class BaseAppV2UITests: XCTestCase {
}


// MARK: - Setup & Tear Down
extension BaseAppV2UITests {
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
        stub(condition: isHost((URL(string: "https://api.baseapp.tsl.io/v1/")?.host)!) && isPath("/v1/users/me") && isMethodGET(), response: { _ in
            guard let path = OHPathForFile("currentuser.json", type(of: self)) else {
                preconditionFailure("Could Not Find Test File!")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: "https://api.baseapp.tsl.io/v1/")?.host)!) && isPath("/v1/users/210") && isMethodPATCH(), response: { _ in
            guard let path = OHPathForFile("updateuser.json", type(of: self)) else {
                preconditionFailure("Could Not Find Test File!")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: "https://api.baseapp.tsl.io/v1/")?.host)!) && isPath("/v1/login") && isMethodPOST(), response: { _ in
            guard let path = OHPathForFile("loginuser.json", type(of: self)) else {
                preconditionFailure("Could Not Find Test File!")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: "https://api.baseapp.tsl.io/v1/")?.host)!) && isPath("/v1/register") && isMethodPOST(), response: { _ in
            guard let path = OHPathForFile("registeruser.json", type(of: self)) else {
                preconditionFailure("Could Not Find Test File!")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type":"application/json"])
        })
    }
    
    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }
}


// MARK: - Flow Tests
extension BaseAppV2UITests {
    func testSignupFlow() {
    }
    
    func testLoginFlow() {
    }
}
