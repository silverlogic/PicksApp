//
//  ChnagePasswordViewModelTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 4/10/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
@testable import BaseAppV2

final class ChangePasswordViewModelTests: BaseAppV2UnitTests {
    
    // MARK: - Initialization Tests
    func testInit() {
        let changePasswordViewModel = ViewModelsManager.changePasswordViewModel()
        XCTAssertNotNil(changePasswordViewModel, "Value Should Not Be Nil!")
        XCTAssertEqual(changePasswordViewModel.currentPassword, "", "Initialization Failed!")
        XCTAssertEqual(changePasswordViewModel.newPassword, "", "Initialization Failed!")
        XCTAssertNil(changePasswordViewModel.changePasswordError.value, "Value Should Be Nil!")
        XCTAssertFalse(changePasswordViewModel.changePasswordSuccess.value, "Value Should Be False!")
    }
    
    func testChangePassword() {
        let changePasswordViewModel = ViewModelsManager.changePasswordViewModel()
        let changePasswordErrorExpectation = expectation(description: "Test Change Password Error Expectation!")
        let changePasswordSuccessExpectation = expectation(description: "Test Change Password Success Expectation!")
        changePasswordViewModel.changePasswordError.bind { (error: BaseError?) in
            changePasswordViewModel.currentPassword = "1234"
            changePasswordViewModel.newPassword = "1235"
            changePasswordViewModel.changePassword()
            changePasswordErrorExpectation.fulfill()
        }
        changePasswordViewModel.changePasswordSuccess.bind { (success: Bool) in
            changePasswordSuccessExpectation.fulfill()
        }
        changePasswordViewModel.changePassword()
        waitForExpectations(timeout: 10, handler: nil)
    }
}
