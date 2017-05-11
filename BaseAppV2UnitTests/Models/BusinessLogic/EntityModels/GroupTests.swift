//
//  GroupTests.swift
//  BaseAppV2
//
//  Created by Michael Sevy on 5/18/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
import CoreData
@testable import BaseAppV2

final class GroupTests: BaseAppV2UnitTests {

    // MARK: - Functionality Tests
    func numberOfParticipantsTest() {
        guard let group = NSEntityDescription.insertNewObject(forEntityName: Group.entityName, into: CoreDataStack.shared.managedObjectContext) as? Group else {
            XCTFail("Failed To Test CoreDataStack!")
            return
        }
        let participants: [Int16]?
        participants = [11, 13]
        group.participants = participants
        XCTAssertNotNil(group.participants!, "Failing To Fetch Group Particiapnts!")
    }
}
