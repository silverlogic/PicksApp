//
//  ForgotPasswordViewModelTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/29/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
@testable import BaseAppV2

final class ForgotPasswordViewModelTests: BaseAppV2UnitTests {
    
    // MARK: - Initialization Tests
    func testInit() {
        let forgotPasswordViewModel = ViewModelsManager.forgotPasswordViewModel(token: nil)
        XCTAssertNotNil(forgotPasswordViewModel, "Value Should Not Be Nil!")
        XCTAssertEqual(forgotPasswordViewModel.email, "", "Initialization Failed!")
        XCTAssertEqual(forgotPasswordViewModel.newPassword, "", "Initialization Failed!")
        XCTAssertNil(forgotPasswordViewModel.forgotPasswordError.value, "Initialization Failed!")
        XCTAssertFalse(forgotPasswordViewModel.forgotPasswordRequestSuccess.value, "Initialization Failed!")
        XCTAssertFalse(forgotPasswordViewModel.forgotPasswordResetSuccess.value, "Initialization Failed!")
    }
    
    
    // MARK: - Functional Tests
    func testForgotPasswordRequest() {
        let forgotPasswordViewModel = ViewModelsManager.forgotPasswordViewModel(token: nil)
        let forgotPasswordRequestExpectation = expectation(description: "Test Forgot Password Expectation")
        let forgotPasswordRequestErrorExpectation = expectation(description: "Test Forgot Password Error Expectation")
        forgotPasswordViewModel.forgotPasswordError.bind { (error: BaseError?) in
            forgotPasswordViewModel.email = "testuser@tsl.io"
            forgotPasswordViewModel.forgotPasswordRequest()
            forgotPasswordRequestErrorExpectation.fulfill()
        }
        forgotPasswordViewModel.forgotPasswordRequestSuccess.bind { (success: Bool) in
            forgotPasswordRequestExpectation.fulfill()
        }
        forgotPasswordViewModel.forgotPasswordRequest()
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testForgotPasswordReset() {
        let forgotPasswordViewModel = ViewModelsManager.forgotPasswordViewModel(token: "AAADCC32jjsxndiehroens38er8f8wyq3rg32")
        let forgotPasswordResetExpectation = expectation(description: "Test Forgot Password Expectation")
        let forgotPasswordResetErrorExpectation = expectation(description: "Test Forgot Password Error Expectation")
        forgotPasswordViewModel.forgotPasswordError.bind { (error: BaseError?) in
            forgotPasswordViewModel.newPassword = "1235"
            forgotPasswordViewModel.forgotPasswordReset()
            forgotPasswordResetErrorExpectation.fulfill()
        }
        forgotPasswordViewModel.forgotPasswordResetSuccess.bind { (success: Bool) in
            forgotPasswordResetExpectation.fulfill()
        }
        forgotPasswordViewModel.forgotPasswordReset()
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testCancelResetPassword() {
        let forgotPasswordViewModel = ViewModelsManager.forgotPasswordViewModel(token: "AAADCC32jjsxndiehroens38er8f8wyq3rg32")
        forgotPasswordViewModel.cancelResetPassword()
    }
}
