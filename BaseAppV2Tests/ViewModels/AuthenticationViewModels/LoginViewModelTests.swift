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
    
    func testLoginWithFacebook() {
        let loginWithFacebookExpectation = expectation(description: "Test Login With Facebook")
        let loginViewModel = LoginViewModel()
        loginViewModel.loginError.bind { (error: BaseError?) in
            XCTFail("Error Logging In With Facebook!")
            loginWithFacebookExpectation.fulfill()
        }
        loginViewModel.loginSuccess.bind { (success: Bool) in
            loginWithFacebookExpectation.fulfill()
        }
        let redirectUrlWithQueryParameters = URL(string: "https://app.baseapp.tsl.io/?code=AQAf7IEllTmPlGXimVmK4A7ksXxRLU75FoiXO7lmc7sncGGvHG-o2_73Y5S2FrhPQvKicHm3kByu--Ou0hk2eRp9jFwArTrkbpXn2CljaG3BFWwNC6aSnruJmt-dHv1_9u-54xRYTSelP89WOqWGewEPWD5Sw1TgPiOXTHPebz3eiH43PTwm0KQhp2AFWSl7Q2zbkF0186yInZVL7JS4ms9phm8k7FF5OiEGBPMUFHMDzpCGewGmTAU5XJwGtZBiEitpftI6UmblIQQ0GuACm0S8qRTM_F5Xg2RBHFhZdw4-EgQ3qlQSxqfcwKZ9OxH4PP0#_=_")!
        loginViewModel.redirectUrlWithQueryParameters = redirectUrlWithQueryParameters
        loginViewModel.loginWithFacebook(email: nil)
        waitForExpectations(timeout: 10, handler: nil)
    }
}
