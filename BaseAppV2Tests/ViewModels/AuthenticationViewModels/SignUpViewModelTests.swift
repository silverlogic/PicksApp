//
//  SignUpViewModelTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/13/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
@testable import BaseAppV2

final class SignUpViewModelTests: BaseAppV2Tests {
}


// MARK: - Initialization Tests
extension SignUpViewModelTests {
    func testInit() {
        let signUpViewModel = SignUpViewModel()
        XCTAssertNotNil(signUpViewModel, "Value Should Not Be Nil!")
        XCTAssertEqual(signUpViewModel.email, "", "Initialization Failed!")
        XCTAssertEqual(signUpViewModel.password, "", "Initialization Failed!")
        XCTAssertEqual(signUpViewModel.confirmPassword, "", "Initialization Failed!")
        XCTAssertEqual(signUpViewModel.firstName, "", "Initialization Failed!")
        XCTAssertEqual(signUpViewModel.lastName, "", "Initialization Failed!")
        XCTAssertNil(signUpViewModel.signUpError.value, "Initialization Failed!")
        XCTAssertFalse(signUpViewModel.signUpSuccess.value, "Initialization Failed!")
    }
}


// MARK: - Functional Tests
extension SignUpViewModelTests {
    func testSignup() {
        let signUpErrorExpectation = expectation(description: "Test Signup Error")
        let signupSuccessExpectation = expectation(description: "Test Signup")
        let signupViewModel = SignUpViewModel()
        signupViewModel.email = "testuser@tsl.io"
        signupViewModel.password = "1234"
        signupViewModel.confirmPassword = "1234"
        signupViewModel.signUpError.bind { (error: BaseError?) in
            signupViewModel.firstName = "Bob"
            signupViewModel.lastName = "Saget"
            signupViewModel.validateEmail()
            signUpErrorExpectation.fulfill()
        }
        signupViewModel.signUpSuccess.bind { (success: Bool) in
            signupSuccessExpectation.fulfill()
        }
        signupViewModel.signup()
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testValidateEmail() {
        let signUpErrorExpectation = expectation(description: "Test Signup Error")
        let signupSuccessExpectation = expectation(description: "Test Signup")
        let signupViewModel = SignUpViewModel()
        signupViewModel.signUpError.bind { (error: BaseError?) in
            signupViewModel.email = "testuser@tsl.io"
            signupViewModel.validateEmail()
            signUpErrorExpectation.fulfill()
        }
        signupViewModel.signUpSuccess.bind { (success: Bool) in
            signupSuccessExpectation.fulfill()
        }
        signupViewModel.validateEmail()
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testValidatePassword() {
        let signUpErrorExpectation = expectation(description: "Test Signup Error")
        let signupSuccessExpectation = expectation(description: "Test Signup")
        let signupViewModel = SignUpViewModel()
        signupViewModel.signUpError.bind { (error: BaseError?) in
            signupViewModel.password = "1234"
            signupViewModel.confirmPassword = "1234"
            signupViewModel.validatePassword()
            signUpErrorExpectation.fulfill()
        }
        signupViewModel.signUpSuccess.bind { (success: Bool) in
            signupSuccessExpectation.fulfill()
        }
        signupViewModel.validatePassword()
        let signUpMismatchErrorExpectation = expectation(description: "Test Signup Error Mismatch")
        let signupMismatchSuccessExpectation = expectation(description: "Test Signup Mismatch")
        let signupViewModelTwo = SignUpViewModel()
        signupViewModelTwo.password = "1234"
        signupViewModelTwo.confirmPassword = "1235"
        signupViewModelTwo.signUpError.bind { (error: BaseError?) in
            signupViewModelTwo.password = "1234"
            signupViewModelTwo.confirmPassword = "1234"
            signupViewModelTwo.validatePassword()
            signUpMismatchErrorExpectation.fulfill()
        }
        signupViewModelTwo.signUpSuccess.bind { (success: Bool) in
            signupMismatchSuccessExpectation.fulfill()
        }
        signupViewModelTwo.validatePassword()
        waitForExpectations(timeout: 10, handler: nil)
    }
}
