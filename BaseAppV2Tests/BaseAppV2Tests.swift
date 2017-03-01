//
//  BaseAppV2Tests.swift
//  BaseAppV2Tests
//
//  Created by Emanuel  Guerrero on 2/28/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
@testable import BaseAppV2

class BaseAppV2Tests: XCTestCase {
    
    // MARK: - Attributes
    // Put any variables needed for testing. This includes instances
    // of any classes that you create
}


// MARK: - Setup & Tear Down
extension BaseAppV2Tests {
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        super.tearDown()
        // Put teardown code here. This method is called after the invocation of each test method in the class.
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
