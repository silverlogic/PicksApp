//
//  UserFeedViewModelTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/30/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
@testable import BaseAppV2

final class UserFeedViewModelTests: BaseAppV2Tests {
    
    // MARK: - Initialization Tests
    func testInit() {
        let userFeedViewModel = UserFeedViewModel()
        XCTAssertNotNil(userFeedViewModel, "Value Should Not Be Nil!")
        XCTAssertEqual(userFeedViewModel.numberOfUsers.value, 0, "Initialization Failed!")
        XCTAssertNil(userFeedViewModel.insertionPositions.value, "Initialization Failed!")
        XCTAssertNil(userFeedViewModel.fetchUsersError.value, "Initialization Failed!")
    }
    
    
    // MARK: - Functional Tests
    func testFetchUsers() {
        let userFeedViewModel = UserFeedViewModel()
        let fetchUsersExpectation = expectation(description: "Test Fetch Users")
        userFeedViewModel.fetchUsersError.bind { (error: BaseError?) in
            XCTFail("Error Fetching Users!")
            fetchUsersExpectation.fulfill()
        }
        userFeedViewModel.insertionPositions.bind { (insertionPositions: [IndexPath]?) in
            XCTAssertTrue(userFeedViewModel.numberOfUsers.value == 30, "Incorrect Count!")
            fetchUsersExpectation.fulfill()
        }
        userFeedViewModel.fetchUsers(clean: false)
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testUserWithIndex() {
        let userFeedViewModel = UserFeedViewModel()
        let fetchUsersExpectation = expectation(description: "Test Fetch Users")
        userFeedViewModel.fetchUsersError.bind { (error: BaseError?) in
            XCTFail("Error Fetching Users!")
            fetchUsersExpectation.fulfill()
        }
        userFeedViewModel.insertionPositions.bind { (insertionPositions: [IndexPath]?) in
            let testUser = userFeedViewModel.userWithIndex(0)
            XCTAssertNotNil(testUser, "Value Should Be Not Nil!")
            let testUser2 = userFeedViewModel.userWithIndex(userFeedViewModel.numberOfUsers.value)
            XCTAssertNil(testUser2, "Value Should Be Nil!")
            fetchUsersExpectation.fulfill()
        }
        userFeedViewModel.fetchUsers(clean: false)
        waitForExpectations(timeout: 10, handler: nil)
    }
}
