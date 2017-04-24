//
//  ChangeEmailVerifyViewModelTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 4/4/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
@testable import BaseAppV2

final class ChangeEmailVerifyViewModelTests: BaseAppV2UnitTests {
    
    // MARK: - Initialization Tests
    func testInit() {
        let changeEmailVerifyViewModel = ChangeEmailVerifyViewModel(token: "hjdsahcaHjHUY89UGBVVYBJ898yugew", userId: 1)
        XCTAssertNotNil(changeEmailVerifyViewModel, "Value Should Not Be Nil!")
        XCTAssertNil(changeEmailVerifyViewModel.changeEmailVerifyError.value, "Value Should Be Nil!")
        XCTAssertFalse(changeEmailVerifyViewModel.changeEmailVerifySuccess.value, "Value Should Be False!")
    }
    
    func testChangeEmailVerify() {
        let changeEmailVerifyViewModel = ChangeEmailVerifyViewModel(token: "hjdsahcaHjHUY89UGBVVYBJ898yugew", userId: 1)
        let changeEmailVerifyExpectation = expectation(description: "Test Change Email Verify")
        changeEmailVerifyViewModel.changeEmailVerifyError.bind { (error: BaseError?) in
            XCTFail("Error Doing Change Email Verify!")
            changeEmailVerifyExpectation.fulfill()
        }
        changeEmailVerifyViewModel.changeEmailVerifySuccess.bind { (success: Bool) in
            changeEmailVerifyExpectation.fulfill()
        }
        changeEmailVerifyViewModel.changeEmailVerify()
        waitForExpectations(timeout: 10, handler: nil)
    }
}
