//
//  UIStoryboardExtensionTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 4/3/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
@testable import BaseAppV2

final class UIStoryboardExtensionTests: BaseAppV2Tests {
    
    // MARK: - Functional Tests
    func testLoadInitializeViewController() {
        let baseTabBarController = UIStoryboard.loadInitialViewController()
        XCTAssertNotNil(baseTabBarController, "Value Should Not Be Nil!")
    }
    
    func testLoadLoginViewController() {
        let loginViewController = UIStoryboard.loadLoginViewController()
        XCTAssertNotNil(loginViewController, "Value Should Not Be Nil!")
    }
    
    func testLoadForgotPasswordResetViewController() {
        let forgotPasswordViewController = UIStoryboard.loadForgotPasswordResetViewController()
        XCTAssertNotNil(forgotPasswordViewController, "Value Should Not Be Nil!")
    }
}
