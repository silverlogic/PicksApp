//
//  ForgotPasswordViewModelTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/29/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
@testable import BaseAppV2

final class ForgotPasswordViewModelTests: BaseAppV2Tests {
}


// MARK: - Functional Tests
extension ForgotPasswordViewModelTests {
    func testForgotPasswordRequest() {
        let forgotPasswordViewModel = ForgotPasswordViewModel(token: nil)
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
        let forgotPasswordViewModel = ForgotPasswordViewModel(token: "AAADCC32jjsxndiehroens38er8f8wyq3rg32")
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
}
