//
//  UIViewControllerExtensionTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/9/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
@testable import BaseAppV2

final class UIViewControllerExtensionTests: BaseAppV2UnitTests {
    
    // MARK: - Functional Tests
    func testStoryboardIdentifier() {
        XCTAssertEqual(LoginViewController.storyboardIdentifier, "LoginViewController", "Incorrect Format!")
        XCTAssertEqual(UITabBarController.storyboardIdentifier, "UITabBarController", "Incorrect Format!")
    }
}
