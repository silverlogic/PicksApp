//
//  CoreDataStackTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/13/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
import CoreData
@testable import BaseAppV2

final class CoreDataStackTests: BaseAppV2Tests {
}


// MARK: - Functional Tests
extension CoreDataStackTests {
    func testFetchObjects() {
        guard let user = NSEntityDescription.insertNewObject(forEntityName: User.entityName, into: CoreDataStack.shared.managedObjectContext) as? User else {
            XCTFail("Failed To Test CoreDataStack!")
            return
        }
        user.userId = 1
        let predicate = NSPredicate(format: "userId == %d", user.userId)
        let fetchExpectation = expectation(description: "Test Fetching Objects")
        CoreDataStack.shared.fetchObjects(predicate: predicate, sortDescriptors: nil, entityType: User.self, success: { (users: [User]) in
            XCTAssertTrue(users.count == 1, "Incorrect amount of objects retrieved!")
            guard let fetchedUser = users.first else {
                XCTFail("Error Getting Fetched User!")
                fetchExpectation.fulfill()
                return
            }
            XCTAssertEqual(user.userId, fetchedUser.userId, "Incorrect user fetched!")
            fetchExpectation.fulfill()
        }) {
            XCTFail("Error Fetching User")
            fetchExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testDeleteObject() {
        guard let user = NSEntityDescription.insertNewObject(forEntityName: User.entityName, into: CoreDataStack.shared.managedObjectContext) as? User else {
            XCTFail("Failed To Test CoreDataStack!")
            return
        }
        user.userId = 2
        let deletetionExpectation = expectation(description: "Test Deleting Object")
        let fetchExpectation = expectation(description: "Test Fetching Objects")
        CoreDataStack.shared.deleteObject(user, success: {
            let predicate = NSPredicate(format: "userId == %d", user.userId)
            CoreDataStack.shared.fetchObjects(predicate: predicate, sortDescriptors: nil, entityType: User.self, success: { (users: [User]) in
                XCTAssertTrue(users.isEmpty, "Incorrect amount of objects retrieved!")
                fetchExpectation.fulfill()
            }) {
                XCTFail("Error Fetching User")
                fetchExpectation.fulfill()
            }
            deletetionExpectation.fulfill()
        }) {
            XCTFail("Error Deleting Object!")
            deletetionExpectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
}
