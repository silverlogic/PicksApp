//
//  AuthenticationManagerTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/13/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
@testable import BaseAppV2

final class AuthenticationManagerTests: BaseAppV2Tests {
    
    // MARK: - Attributes
    fileprivate var sharedManager: AuthenticationManager!
}


// MARK: - Setup & Tear Down
extension AuthenticationManagerTests {
    override func setUp() {
        super.setUp()
        sharedManager = AuthenticationManager.shared
    }
    
    override func tearDown() {
        super.tearDown()
        sharedManager = nil
    }
}


// MARK: - Functional Tests
extension AuthenticationManagerTests {
    func testLogin() {
        let loginExpectation = expectation(description: "Test Login")
        sharedManager.login(email: "testuser@tsl.io", password: "1234", success: {
            XCTAssertNotNil(SessionManager.shared.currentUser, "Value Should Not Be Nil!")
            XCTAssertEqual(SessionManager.shared.currentUser?.userId, 210, "Wrong User Loaded!")
            loginExpectation.fulfill()
        }) { (error: BaseError) in
            XCTFail("Error Logging In!")
            loginExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testSignup() {
        let signupInfo = SignUpInfo(email: "testuser@tsl.io", password: "1234", referralCodeOfReferrer: nil)
        let updateIndo = UpdateInfo(referralCodeOfReferrer: nil, avatarBaseString: nil, firstName: "Bob", lastName: "Saget")
        let signupExpectation = expectation(description: "Test Signup")
        sharedManager.signup(signupInfo, updateInfo: updateIndo, success: {
            XCTAssertNotNil(SessionManager.shared.currentUser, "Value Should Not Be Nil!")
            XCTAssertEqual(SessionManager.shared.currentUser?.userId, 210, "Signing Up User Failed!")
            XCTAssertEqual(SessionManager.shared.currentUser?.email, "testuser@tsl.io", "Signing Up User Failed!")
            XCTAssertEqual(SessionManager.shared.currentUser?.firstName, "Bob", "Signing Up User Failed!")
            XCTAssertEqual(SessionManager.shared.currentUser?.lastName, "Saget", "Signing Up User Failed!")
            signupExpectation.fulfill()
        }) { (error: BaseError) in
            XCTFail("Error Signing Up!")
            signupExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testLoginWithOAuth2() {
        let redirectUrlWithQueryParameters = URL(string: "https://app.baseapp.tsl.io/?code=AQAf7IEllTmPlGXimVmK4A7ksXxRLU75FoiXO7lmc7sncGGvHG-o2_73Y5S2FrhPQvKicHm3kByu--Ou0hk2eRp9jFwArTrkbpXn2CljaG3BFWwNC6aSnruJmt-dHv1_9u-54xRYTSelP89WOqWGewEPWD5Sw1TgPiOXTHPebz3eiH43PTwm0KQhp2AFWSl7Q2zbkF0186yInZVL7JS4ms9phm8k7FF5OiEGBPMUFHMDzpCGewGmTAU5XJwGtZBiEitpftI6UmblIQQ0GuACm0S8qRTM_F5Xg2RBHFhZdw4-EgQ3qlQSxqfcwKZ9OxH4PP0#_=_")!
        let redirectUrl = "https://app.baseapp.tsl.io/"
        let loginWithFacebookExpectation = expectation(description: "Test OAuth Login For Facebook")
        sharedManager.loginWithOAuth2(redirectUrlWithQueryParameters: redirectUrlWithQueryParameters, redirectUri: redirectUrl, provider: .facebook, email: nil, success: { 
            XCTAssertNotNil(SessionManager.shared.currentUser, "Value Should Not Be Nil!")
            loginWithFacebookExpectation.fulfill()
        }) { (error: BaseError) in
            XCTFail("Error Logging In With OAuth2!")
            loginWithFacebookExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
