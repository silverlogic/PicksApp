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

    func testFetchGroupsForUser() {
        let fetchGroupsExpectation = expectation(description: "Test Fetching Groups!")
        let fetchGroupsViewModel = ViewModelsManager.groupQueryForCurrentUserViewModel()
        fetchGroupsViewModel.fetchGroupsError.bind { (error) in
            XCTFail("Error Fetching A Group!")
            fetchGroupsExpectation.fulfill()
        }
        fetchGroupsViewModel.groupsFetched.bind{ (success) in
            XCTAssertEqual(fetchGroupsViewModel.numberOfGroups(), 2, "Error Fetching Groups")
            let group = fetchGroupsViewModel.groupForIndex(2)
            XCTAssertNil(group, "Value Should Be Nil!")
            let groupTwo = fetchGroupsViewModel.groupForIndex(0)
            XCTAssertNotNil(groupTwo, "Value Should Not Be Nil!")
            fetchGroupsExpectation.fulfill()
        }
        fetchGroupsViewModel.fetchGroups()
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testFetchGroupsForPublic() {
        let fetchGroupsExpectation = expectation(description: "Test Fetching Groups!")
        let fetchGroupsViewModel = ViewModelsManager.groupQueryForPublicGroupsViewModel()
        fetchGroupsViewModel.fetchGroupsError.bind { (error) in
            XCTFail("Error Fetching A Group!")
            fetchGroupsExpectation.fulfill()
        }
        fetchGroupsViewModel.groupsFetched.bind{ (success) in
            XCTAssertEqual(fetchGroupsViewModel.numberOfGroups(), 2, "Error Fetching Groups")
            let group = fetchGroupsViewModel.groupForIndex(2)
            XCTAssertNil(group, "Index Shold Be Nil")
            let groupTwo = fetchGroupsViewModel.groupForIndex(0)
            XCTAssertNotNil(groupTwo, "Value Should Be Not Nil")
            fetchGroupsExpectation.fulfill()
        }
        fetchGroupsViewModel.fetchGroups()
        waitForExpectations(timeout: 10, handler: nil)
    }
}
