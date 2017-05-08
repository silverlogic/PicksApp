//
//  WeakTests.swift
//  BaseAppV2
//
//  Created by Vasilii Muravev on 5/1/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
@testable import BaseAppV2

class WeakTests: BaseAppV2UnitTests {
    
    func testWeak() {
        let weakWeak = Weak(NSObject())
        XCTAssertNil(weakWeak.value, "Value Should Be Nil!")
        let strongValue = NSObject()
        let weakStrong = Weak(strongValue)
        XCTAssertNotNil(weakStrong.value, "Value Should Not Be Nil!")
    }
}
