//
//  GroupQueryViewModel.swift
//  BaseAppV2
//
//  Created by Michael Sevy on 5/18/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
@testable import BaseAppV2

final class GroupQueryViewModelTests: BaseAppV2UnitTests {

    // MARK: - Initialization Tests
    func testInit() {
        let groupQueryUserViewModel = ViewModelsManager.groupQueryForCurrentUserViewModel()
        let groupQueryPublicViewModel = ViewModelsManager.groupQueryForPublicGroupsViewModel()
        XCTAssertNotNil(groupQueryUserViewModel, "Value Should Not Be Nil!")
        XCTAssertFalse(groupQueryUserViewModel.groupsFetched.value, "Initialization Falied")
        XCTAssertNil(groupQueryUserViewModel.fetchGroupsError.value, "Initialization Falied")
        XCTAssertNotNil(groupQueryPublicViewModel, "Value Should Not Be Nil!")
        XCTAssertFalse(groupQueryPublicViewModel.groupsFetched.value, "Initialization Falied")
        XCTAssertNil(groupQueryPublicViewModel.fetchGroupsError.value, "Initialization Falied")
    }

    func testFetchGroups() {
        let fetchGroupsExpectation = expectation(description: "Test Fetching Groups!")
        let fetchGroupsViewModel = ViewModelsManager.groupQueryForCurrentUserViewModel()
        fetchGroupsViewModel.fetchGroupsError.bind { (error) in
            XCTFail("Error Fetching A Group!")
            fetchGroupsExpectation.fulfill()
        }
        fetchGroupsViewModel.groupsFetched.bind { (success) in
            XCTAssertEqual(fetchGroupsViewModel.numberOfGroups(), 4, "Error Fetching Groups")
            let group = fetchGroupsViewModel.groupForIndex(5)
            XCTAssertNil(group, "Value Should Be Nil!")
            let groupTwo = fetchGroupsViewModel.groupForIndex(0)
            XCTAssertNotNil(groupTwo, "Value Should Not Be Nil!")
            fetchGroupsExpectation.fulfill()
        }
        fetchGroupsViewModel.fetchGroupsForUser(userId: 11)
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testJoinGroup() {
        let joinGroupExpectation = expectation(description: "Test Joining a Group")
        let joinGroupViewModel = ViewModelsManager.groupQueryForCurrentUserViewModel()
        joinGroupViewModel.joinSuccess.bind { (success) in
            joinGroupExpectation.fulfill()
        }
        joinGroupViewModel.joinError.bind { (error) in
            XCTFail("Error Joining A Group")
            joinGroupExpectation.fulfill()
        }
        joinGroupViewModel.joinGroup(currentUserId: 11, groupId: 1)
        waitForExpectations(timeout: 10, handler: nil)
    }
}

