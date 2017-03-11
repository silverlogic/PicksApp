//
//  LoginViewModelTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/13/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
@testable import BaseAppV2

final class LoginViewModelTests: BaseAppV2Tests {
}


// MARK: - Initialization Tests
extension LoginViewModelTests {
    func testInit() {
        let loginViewModel = LoginViewModel()
        XCTAssertNotNil(loginViewModel, "Value Should Not Be Nil!")
        XCTAssertEqual(loginViewModel.email, "", "Initialization Falied")
        XCTAssertEqual(loginViewModel.password, "", "Initialization Falied")
        XCTAssertNil(loginViewModel.loginError.value, "Initialization Falied")
        XCTAssertFalse(loginViewModel.loginSuccess.value, "Initialization Falied")
    }
}


// MARK: - Functional Tests
extension LoginViewModelTests {
    func testLoginWithEmail() {
        let loginErrorExpectation = expectation(description: "Test Login Error")
        let loginExpectation = expectation(description: "Test Login")
        let loginViewModel = LoginViewModel()
        loginViewModel.loginError.bind { (error: BaseError?) in
            loginViewModel.email = "testuser@tsl.io"
            loginViewModel.password = "1234"
            loginViewModel.loginWithEmail()
            loginErrorExpectation.fulfill()
        }
        loginViewModel.loginSuccess.bind { (success: Bool) in
            loginExpectation.fulfill()
        }
        loginViewModel.loginWithEmail()
        waitForExpectations(timeout: 10, handler: nil)
    }
}
