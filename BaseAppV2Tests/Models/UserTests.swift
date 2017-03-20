//
//  UserTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/7/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
import CoreData
@testable import BaseAppV2

final class UserTests: BaseAppV2Tests {
}


// MARK: - Functionality Tests
extension UserTests {
    func testAvatarUrl() {
        guard let user = NSEntityDescription.insertNewObject(forEntityName: User.entityName, into: CoreDataStack.shared.managedObjectContext) as? User else {
            XCTFail("Failed To Test CoreDataStack!")
            return
        }
        user.userId = 50
        let url = URL(string: "https://upload.wikimedia.org/wikipedia/commons/thumb/8/84/Apple_Computer_Logo_rainbow.svg/931px-Apple_Computer_Logo_rainbow.svg.png")!
        user.avatarUrl = url
        XCTAssertEqual(user.avatarUrl, url, "Formatting Not Correct!")
    }
    
    func testFullName() {
        guard let user = NSEntityDescription.insertNewObject(forEntityName: User.entityName, into: CoreDataStack.shared.managedObjectContext) as? User else {
            XCTFail("Failed To Test CoreDataStack!")
            return
        }
        user.userId = 52
        user.firstName = "Bob"
        user.lastName = "Saget"
        let fullName = user.fullName
        XCTAssertEqual(fullName, "Bob Saget", "Formatting Not Correct!")
    }
}
