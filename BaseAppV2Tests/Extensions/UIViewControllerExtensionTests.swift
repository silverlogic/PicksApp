//
//  UIViewControllerExtensionTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/9/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
@testable import BaseAppV2

final class UIViewControllerExtensionTests: BaseAppV2Tests {
}


// MARK: - Functional Tests
extension UIViewControllerExtensionTests {
    func testStoryboardIdentifier() {
        XCTAssertEqual(LoginViewController.storyboardIdentifier, "LoginViewController", "Incorrect Format!")
        XCTAssertEqual(UITabBarController.storyboardIdentifier, "UITabBarController", "Incorrect Format!")
    }
}