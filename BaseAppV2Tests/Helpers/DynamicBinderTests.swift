//
//  DynamicBinderTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 4/7/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
@testable import BaseAppV2

final class DynamicBinderTests: BaseAppV2Tests {
    
    func testDynamicBinder() {
        let dynamicBinder = DynamicBinder(1)
        let bindExpectation = expectation(description: "Test Listener")
        dynamicBinder.bind { (value: Int) in
            bindExpectation.fulfill()
        }
        dynamicBinder.value = 2
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testMultiDynamicBinder() {
        let multiDynamicBinder = MultiDynamicBinder(1)
        let bindExpectation1 = expectation(description: "Test Listener 1")
        let bindExpectation2 = expectation(description: "Test Listener 2")
        multiDynamicBinder.bind({ (value: Int) in
            bindExpectation1.fulfill()
        }, for: self)
        multiDynamicBinder.bind({ (value: Int) in
            bindExpectation2.fulfill()
        }, for: self)
        XCTAssertTrue(multiDynamicBinder.observers.count == 2, "Wrong Count")
        multiDynamicBinder.value = 2
        waitForExpectations(timeout: 10) { (error: Error?) in
            if error != nil {
                XCTFail("Bindings Failed!")
                return
            }
            multiDynamicBinder.removeListeners(for: self)
            XCTAssertTrue(multiDynamicBinder.observers.isEmpty, "Should Be Empty")
        }
    }
}
