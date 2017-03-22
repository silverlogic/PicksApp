//
//  BaseAppV2Tests.swift
//  BaseAppV2Tests
//
//  Created by Emanuel  Guerrero on 2/28/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import BaseAppV2

class BaseAppV2Tests: XCTestCase {
}


// MARK: - Setup & Tear Down
extension BaseAppV2Tests {
    override func setUp() {
        super.setUp()
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/v1/users/me") && isMethodGET(), response: { _ in
            guard let path = OHPathForFile("currentuser.json", type(of: self)) else {
                preconditionFailure("Could Not Find Test File!")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/v1/users/210") && isMethodPATCH(), response: { _ in
            guard let path = OHPathForFile("updateuser.json", type(of: self)) else {
                preconditionFailure("Could Not Find Test File!")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/v1/login") && isMethodPOST(), response: { _ in
            guard let path = OHPathForFile("loginuser.json", type(of: self)) else {
                preconditionFailure("Could Not Find Test File!")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/v1/register") && isMethodPOST(), response: { _ in
            guard let path = OHPathForFile("registeruser.json", type(of: self)) else {
                preconditionFailure("Could Not Find Test File!")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/v1/social-auth") && isMethodPOST(), response: { _ in
            guard let path = OHPathForFile("loginuseroauth.json", type(of: self)) else {
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


// MARK: - Initialization Tests
extension BaseAppV2Tests {
    // Here you would place test methods for testing
    // initialization of objects. This includes
    // testing for IBOutlets are connected, any
    // objects that have data sources and delegates
    // have references, etc.
    func testIBOutletsAreConnected() {
        XCTAssert(true, "Missing Connections")
    }
}


// MARK: - Functional Tests
extension BaseAppV2Tests {
    // Here you would place test methods for testing
    // functionality and behaviors of class objects.
    // This includes testing business logic, searching,
    // filtering, etc.
    func testAddition() {
        let result = 1 + 1
        XCTAssert(result == 2, "Incorrect Answer")
    }
}
