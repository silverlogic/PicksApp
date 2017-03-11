//
//  APIErrorTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/8/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
@testable import BaseAppV2

final class APIErrorTests: BaseAppV2Tests {
}


// MARK: - Initialization Tests
extension APIErrorTests {
    func testInit() {
        let apiError = BaseError(statusCode: 400, errorDescription: "Email entered not correct!")
        XCTAssertNotNil(apiError, "Value Should Not Be Nil!")
        XCTAssertEqual(apiError.statusCode, 400, "Initialization Failed!")
        XCTAssertEqual(apiError.errorDescription, "Email entered not correct!", "Initialization Failed!")
    }
}


// MARK: - Functional Tests
extension APIErrorTests {
    func testErrorDescriptionFromErrorDictionary() {
        let usernameError = BaseError.errorDescriptionFromErrorDictionary(["username":["Username already in use."]])
        XCTAssertEqual(usernameError, "Username already in use. 😞", "Getting Error Description Failed!")
        let unidentifiedError = BaseError.errorDescriptionFromErrorDictionary(["age":["Age not supported."]])
        XCTAssertEqual(unidentifiedError, "Oh no, an unknown error occured. 😞", "Getting Error Description Failed!")
    }
    
    func testGeneric() {
        let genericError = BaseError.generic
        XCTAssertNotNil(genericError, "Value Should Not Be Nil!")
        XCTAssertEqual(genericError.statusCode, 0, "Getting Error Failed!")
        XCTAssertEqual(genericError.errorDescription, "Oh no, an unknown error occured. 😞", "Getting Error Failed!")
    }
    
    func testFieldsEmpty() {
        let fieldsEmptyError = BaseError.fieldsEmpty
        XCTAssertNotNil(fieldsEmptyError, "Value Should Not Be Nil!")
        XCTAssertEqual(fieldsEmptyError.statusCode, 101, "Getting Error Failed!")
        XCTAssertEqual(fieldsEmptyError.errorDescription, "Oops, not all fields enterd. 😞", "Getting Error Failed!")
    }
    
    func testPasswordsDoNotMatch() {
        let passwordsDoNotMatchError = BaseError.passwordsDoNotMatch
        XCTAssertNotNil(passwordsDoNotMatchError, "Value Should Not Be Nil!")
        XCTAssertEqual(passwordsDoNotMatchError.statusCode, 102, "Getting Error Failed!")
        XCTAssertEqual(passwordsDoNotMatchError.errorDescription, "Oops, passwords entered don't match. 😞", "Getting Error Failed!")
    }
}
