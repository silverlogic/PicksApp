//
//  GroupManagerTests.swift
//  BaseAppV2
//
//  Created by Michael Sevy on 5/18/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
import CoreData
@testable import BaseAppV2

final class GroupManagerTests: BaseAppV2UnitTests {

    // MARK: - Private Instance Attributes
    fileprivate var sharedManager: GroupManager!


    // MARK: - Setup & Tear Down
    override func setUp() {
        super.setUp()
        sharedManager = GroupManager.shared
    }

    override func tearDown() {
        super.tearDown()
        sharedManager = nil
    }
}


// MARK: - Functional Tests
extension GroupManagerTests {
    func testFetchGroupForUserAsParticipant() {
        let fetchGroupForParticipantExpectation = expectation(description: "Test Fetching Group For a Participant")
        sharedManager.fetchGroupsForUserAsParticipant(success: { (groups) in
            XCTAssertNotNil(self.sharedManager.fetchGroupsForUserAsParticipant, "Fetching Group Failed!")
            XCTAssertEqual(groups.count, 2, "Incorrect Amount of Groups Retrieved")
            fetchGroupForParticipantExpectation.fulfill()
        }) { (error) in
            XCTFail("Error Getting Group Data!")
            fetchGroupForParticipantExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testFetchGroupForUserAsCreator() {
        let fetchGroupForCreatorExpectation = expectation(description: "Test Fetching Group For A Creator")
        sharedManager.fetchGroupsForUserAsCreator(success: { (groups) in
            XCTAssertNotNil(self.sharedManager.fetchGroupsForUserAsCreator, "Fetching Group Failed!")
            XCTAssertEqual(groups.count, 2, "Incorrect Amount of Groups Retrieved")
            fetchGroupForCreatorExpectation.fulfill()
        }) { (error) in
            XCTFail("Error Getting Group Data!")
            fetchGroupForCreatorExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testFetchAllGroups() {
        let fetchAllGroupsExpectation = expectation(description: "Test Fetching All Groups")
        sharedManager.fetchAllGroups(success: { (groups) in
            XCTAssertNotNil(self.sharedManager.fetchAllGroups, "Fetching Group Failed!")
            XCTAssertEqual(groups.count, 2, "Incorrect Amount of Groups Retrieved")
            fetchAllGroupsExpectation.fulfill()
        }) { (error) in
            XCTFail("Error Getting Group Data!")
            fetchAllGroupsExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testCreateGroup() {
        let createGroupExpextation = expectation(description: "Test Creating A Group")
        sharedManager.postGroup(groupName: "Test Name", success: {
            createGroupExpextation.fulfill()
        }) { (error) in
            XCTFail("Error Creating Group!")
            createGroupExpextation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }

//@TODO when join branch added
//    func testJoinGroup() {
//        let joinGroupExpextation = expectation(description: "Test Joining A Group")
//        sharedManager.joinGroup(groupId: 11, success: {
//            joinGroupExpextation.fulfill()
//        }) { (error) in
//            XCTFail("Error Getting Group Data!")
//            joinGroupExpextation.fulfill()
//        }
//        waitForExpectations(timeout: 10, handler: nil)
//    }
}
