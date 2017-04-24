//
//  ProfileViewModelTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/24/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
import CoreData
@testable import BaseAppV2

final class ProfileViewModelTests: BaseAppV2UnitTests {
    
    // MARK: - Functional Tests
    func testUpdateProfile() {
        guard let user = NSEntityDescription.insertNewObject(forEntityName: User.entityName, into: CoreDataStack.shared.managedObjectContext) as? User else {
            XCTFail("Error Creating Test User Model!")
            return
        }
        SessionManager.shared.currentUser = MultiDynamicBinder(user)
        SessionManager.shared.currentUser.value?.userId = 210
        let updateProfileErrorExpectation = expectation(description: "Test Update Profile Error")
        let updateProfileSuccessExpectation = expectation(description: "Tests Update Profile")
        let profileViewModel = ProfileViewModel(user: SessionManager.shared.currentUser)
        profileViewModel.updateProfileError.bind { (error: BaseError?) in
            profileViewModel.firstName = "Bob"
            profileViewModel.lastName = "Saget"
            profileViewModel.updateProfile()
            updateProfileErrorExpectation.fulfill()
        }
        profileViewModel.updateProfileSuccess.bind { (success: Bool) in
            updateProfileSuccessExpectation.fulfill()
        }
        profileViewModel.updateProfile()
        waitForExpectations(timeout: 10, handler: nil)
    }
}
