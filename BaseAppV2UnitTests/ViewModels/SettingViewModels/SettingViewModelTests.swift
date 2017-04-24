//
//  SettingViewModelTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 4/4/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
@testable import BaseAppV2

final class SettingViewModelTests: BaseAppV2UnitTests {
    
    // MARK: - Functional Tests
    func testLogout() {
        let settingViewModel = SettingViewModel()
        settingViewModel.logout()
    }
    
    func testChangeEmailRequest() {
        let settingViewModel = SettingViewModel()
        let changeEmailRequestErrorExpectation = expectation(description: "Test Change Email Request Error")
        let changeEmailRequestSuccessExpectation = expectation(description: "Test Change Email Request Success")
        settingViewModel.changeEmailRequestError.bind { (error: BaseError?) in
            settingViewModel.changeEmailRequest(newEmail: "testuser@tsl.io")
            changeEmailRequestErrorExpectation.fulfill()
        }
        settingViewModel.changeEmailRequestSuccess.bind { (success: Bool) in
            changeEmailRequestSuccessExpectation.fulfill()
        }
        settingViewModel.changeEmailRequest(newEmail: "")
        waitForExpectations(timeout: 10, handler: nil)
    }
}
