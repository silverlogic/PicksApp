//
//  ConfigurationManagerTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 2/28/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
@testable import BaseAppV2

final class ConfigurationManagerTests: BaseAppV2UnitTests {
    
    // MARK: - Attributes
    fileprivate var _sharedInstance: ConfigurationManager!
    
    
    // MARK: - Setup & Tear Down
    override func setUp() {
        super.setUp()
        _sharedInstance = ConfigurationManager.shared
    }
    
    override func tearDown() {
        super.tearDown()
        _sharedInstance.environmentMode = .staging
        _sharedInstance = nil
    }
}


// MARK: - Functional Tests
extension ConfigurationManagerTests {
    func testEnvironmentMode() {
        _sharedInstance.environmentMode = .staging
        XCTAssertEqual(_sharedInstance.environmentMode, .staging, "Environment Mode Not Correct!")
        _sharedInstance.environmentMode = .local
        XCTAssertEqual(_sharedInstance.environmentMode, .local, "Environment Mode Not Correct!")
        _sharedInstance.environmentMode = .stable
        XCTAssertEqual(_sharedInstance.environmentMode, .stable, "Environment Mode Not Correct!")
        _sharedInstance.environmentMode = .production
        XCTAssertEqual(_sharedInstance.environmentMode, .production, "Environment Mode Not Correct!")
    }
    
    func testFacebookRedirectUri() {
        let redirectUrl = _sharedInstance.facebookRedirectUri
        XCTAssertNotNil(redirectUrl, "Value Should Not Be Nil!")
        XCTAssertEqual(redirectUrl, "https://app.baseapp.tsl.io/", "Getting Redirect Failed!")
    }
    
    func testLinkedInRedirectUri() {
        let redirectUrl = _sharedInstance.linkedInRedirectUri
        XCTAssertNotNil(redirectUrl, "Value Should Not Be Nil!")
        XCTAssertEqual(redirectUrl, "https://app.baseapp.tsl.io/", "Getting Redirect Failed!")
    }
    
    func testTwitterRedirectUri() {
        let redirectUrl = _sharedInstance.twitterRedirectUri
        XCTAssertNotNil(redirectUrl, "Value Should Not Be Nil!")
        XCTAssertEqual(redirectUrl, "https://app.baseapp.tsl.io/", "Getting Redirect Failed!")
    }
    
    func testApiUrl() {
        _sharedInstance.environmentMode = .local
        guard let localApiUrl = _sharedInstance.apiUrl else {
            XCTFail("Error Getting Api Url From Global Configuration!")
            return
        }
        XCTAssertEqual(localApiUrl, "https://api.baseapp.tsl.io/v2/", "Wrong Value Retrived!")
        _sharedInstance.environmentMode = .staging
        guard let stagingApiUrl = _sharedInstance.apiUrl else {
            XCTFail("Error Getting Api Url From Global Configuration!")
            return
        }
        XCTAssertEqual(stagingApiUrl, "https://api.baseapp.tsl.io/v1/", "Wrong Value Retrived!")
        _sharedInstance.environmentMode = .stable
        guard let stableApiUrl = _sharedInstance.apiUrl else {
            XCTFail("Error Getting Api Url From Global Configuration!")
            return
        }
        XCTAssertEqual(stableApiUrl, "https://api.baseapp.tsl.io/v3/", "Wrong Value Retrived!")
        _sharedInstance.environmentMode = .production
        guard let productionApiUrl = _sharedInstance.apiUrl else {
            XCTFail("Error Getting Api Url From Global Configuration!")
            return
        }
        XCTAssertEqual(productionApiUrl, "https://api.baseapp.tsl.io/v4/", "Wrong Value Retrived!")
    }
    
    func testFacebookOAuthUrl() {
        let url = _sharedInstance.facebookOAuthUrl
        XCTAssertNotNil(url, "Value Should Not Be Nil!")
        XCTAssertEqual(url, URL(string:"https://www.facebook.com/dialog/oauth?client_id=973634146036464&redirect_uri=https://app.baseapp.tsl.io/&scope=email,public_profile"), "Getting Url Failed!")
    }
    
    func testLinkedInOAuthUrl() {
        let url = _sharedInstance.linkedInOAuthUrl
        XCTAssertNotNil(url, "Value Should Not Be Nil!")
        XCTAssertEqual(url, URL(string: "https://www.linkedin.com/oauth/v2/authorization?response_type=code&client_id=781ehwqhni34oe&redirect_uri=https://app.baseapp.tsl.io/&scope=r_basicprofile%20r_emailaddress"), "Getting Url Falied!")
    }
}
