//
//  GroupDetailViewModelTests.swift
//  BaseAppV2
//
//  Created by Michael Sevy on 5/31/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
import CoreData
@testable import BaseAppV2

final class GroupDetailViewModelTest: BaseAppV2UnitTests {

    // MARK: - Initialization Tests
    func testInit() {
        guard let group = NSEntityDescription.insertNewObject(forEntityName: Group.entityName, into: CoreDataStack.shared.managedObjectContext) as? Group else {
            XCTFail("Failed to Initialize Group Object!")
            return
        }
        let groupDetailsViewModel = ViewModelsManager.groupDetailViewModel(group: group)
        XCTAssertNotNil(groupDetailsViewModel, "Value Should Not be Nil!")
        XCTAssertFalse(groupDetailsViewModel.fetchedParticipantsSuccess.value, "Initialization Failed!")
        XCTAssertFalse(groupDetailsViewModel.joinSuccess.value, "Initializaton Failed!")
        XCTAssertNil(groupDetailsViewModel.fetchedParticipantsError.value, "Initialization Failed!")
        XCTAssertNil(groupDetailsViewModel.joinError.value, "Initializaton Failed!")
    }

    func testFetchPartcipantsForCurrentUser() {
        guard let group = NSEntityDescription.insertNewObject(forEntityName: Group.entityName, into: CoreDataStack.shared.managedObjectContext) as? Group else {
            XCTFail("Failed to Initialize Group Object!")
            return
        }
        group.groupId = 4
        group.currentSeason = 117
        group.creatorId = 18
        guard let user = NSEntityDescription.insertNewObject(forEntityName: User.entityName, into: CoreDataStack.shared.managedObjectContext) as? User else {
            XCTFail("Failed to Initialize Group Object!")
            return
        }
        user.userId = 11
        let groupDetailExpectation = expectation(description: "Test Fetching Group Details")
        let groupDetailViewModel = ViewModelsManager.groupDetailViewModel(group: group)
        groupDetailViewModel.fetchedParticipantsError.bind { (error) in
            XCTFail("Failed to Fetch a Group With Participants")
            groupDetailExpectation.fulfill()
        }
        groupDetailViewModel.fetchedParticipantsSuccess.bind { (success) in
            XCTAssertNotNil(groupDetailViewModel.isUserMember(), "User Member is Not Nil!")
            groupDetailExpectation.fulfill()
        }
        groupDetailViewModel.retrieveDetails(currentUser: user)
        waitForExpectations(timeout: 10, handler: nil)
    }
}
