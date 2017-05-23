//
//  GroupCreationViewModelTest.swift
//  BaseAppV2
//
//  Created by Michael Sevy on 5/18/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
@testable import BaseAppV2

final class GroupViewModelTests: BaseAppV2UnitTests {

    // MARK: - Initialization Tests
    func testInit() {
        let groupViewModel = ViewModelsManager.groupCreationViewModel()
        XCTAssertNotNil(groupViewModel, "Value Should Not Be Nil!")
        XCTAssertEqual(groupViewModel.groupName, "", "Initialization Falied")
        XCTAssertEqual(groupViewModel.numberOfPeople.hashValue, 0, "Initialization Falied")
        XCTAssertNil(groupViewModel.creationError.value, "Initialization Falied")
        XCTAssertFalse(groupViewModel.creationSuccess.value, "Initialization Falied")
        XCTAssertNil(groupViewModel.joinError.value, "Initialization Falied")
        XCTAssertFalse(groupViewModel.joinSuccess.value, "Initialization Falied")
    }

    func testCreateGroupWithBlankString() {
        let createGroupExpectation = expectation(description: "Test Create Group!")
        let createGroupViewModel = ViewModelsManager.groupCreationViewModel()
        createGroupViewModel.creationError.bind { (error) in
            createGroupExpectation.fulfill()
        }
        createGroupViewModel.creationSuccess.bind { (success) in
            XCTFail("Validation Failed!")
            createGroupExpectation.fulfill()
        }
        createGroupViewModel.createGroup(name: "")
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testCreateGroupWithMaxCharacters() {
        let createGroupExpectation = expectation(description: "Test Create Group!")
        let createGroupViewModel = ViewModelsManager.groupCreationViewModel()
        createGroupViewModel.creationError.bind { (error) in
            createGroupExpectation.fulfill()
        }
        createGroupViewModel.creationSuccess.bind { (success) in
            XCTFail("Validation Failed!")
            createGroupExpectation.fulfill()
        }
        createGroupViewModel.createGroup(name: "abdaefiewfbefit2497r2389rgou4fty3948g6rvtr9ev8v")
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testCreateGroup() {
        let createGroupExpectation = expectation(description: "Test Create Group!")
        let createGroupViewModel = ViewModelsManager.groupCreationViewModel()
        createGroupViewModel.creationError.bind { (error) in
            XCTFail("Validation Failed!")
            createGroupExpectation.fulfill()
        }
        createGroupViewModel.creationSuccess.bind { (success) in
            createGroupExpectation.fulfill()
        }
        createGroupViewModel.createGroup(name: "My Group1")
        waitForExpectations(timeout: 10, handler: nil)
    }
}
