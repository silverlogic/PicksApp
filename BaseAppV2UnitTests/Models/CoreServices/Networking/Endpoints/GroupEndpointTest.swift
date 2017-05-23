//
//  GroupEndpointTest.swift
//  BaseAppV2
//
//  Created by Michael Sevy on 5/18/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
import Alamofire
@testable import BaseAppV2

final class GroupEndpointTests: BaseAppV2UnitTests {

    // MARK: - Functional Tests
    func testPostGroupEndpoint() {
        let user = SessionManager.shared.currentUser.value
        let postEndpoint = GroupEndpoint.post(groupName: "My Group", creator: user!, isPrivate: false)
        XCTAssertNotNil(postEndpoint, "Value Should Not Be Nil!")
        XCTAssertEqual(postEndpoint.endpointInfo.path, "Groups", "Path Not Correct!")
        XCTAssertEqual(postEndpoint.endpointInfo.requestMethod, .post, "Request Method Not Correct!")
        XCTAssertNotNil(postEndpoint.endpointInfo.parameters, "Value Should Not Be Nil!")
        XCTAssertTrue(postEndpoint.endpointInfo.parameterEncoding is JSONEncoding, "Encoding Not Correct!")
        XCTAssertTrue(postEndpoint.endpointInfo.requiresAuthorization, "Value Should Be True!")
    }

    func testJoinGroup() {
        let user = SessionManager.shared.currentUser.value
        let joinEndpoint = GroupEndpoint.join(groupId: 11, user: user!)
        XCTAssertNotNil(joinEndpoint, "Value Should Not Be Nil!")
        XCTAssertEqual(joinEndpoint.endpointInfo.path, "Groups/11/join", "Path Not Correct!")
        XCTAssertEqual(joinEndpoint.endpointInfo.requestMethod, .post, "Request Method Not Correct!")
        XCTAssertNotNil(joinEndpoint.endpointInfo.parameters, "Value Should Not Be Nil!")
        XCTAssertTrue(joinEndpoint.endpointInfo.parameterEncoding is JSONEncoding, "Encoding Not Correct!")
        XCTAssertTrue(joinEndpoint.endpointInfo.requiresAuthorization, "Value Should Be True!")
    }

    func testGroupsCreator() {
        let groupsCreatorEndpoint = GroupEndpoint.groupsCreator(creatorId: 11, isPrivate: false)
        XCTAssertNotNil(groupsCreatorEndpoint, "Value Should Not Be Nil!")
        XCTAssertEqual(groupsCreatorEndpoint.endpointInfo.path, "Groups/groupsForCreator", "Path Not Correct!")
        XCTAssertEqual(groupsCreatorEndpoint.endpointInfo.requestMethod, .get, "Request Method Not Correct!")
        XCTAssertNotNil(groupsCreatorEndpoint.endpointInfo.parameters, "Value Should Not Be Nil!")
        XCTAssertTrue(groupsCreatorEndpoint.endpointInfo.parameterEncoding is URLEncoding, "Encoding Not Correct!")
        XCTAssertTrue(groupsCreatorEndpoint.endpointInfo.requiresAuthorization, "Value Should Be True!")
    }
    func testGroupsParticipant() {
        let groupsPaticipant = GroupEndpoint.groupsParticipant(participantId: 11, isPrivate: false)
        XCTAssertNotNil(groupsPaticipant, "Value Should Not Be Nil!")
        XCTAssertEqual(groupsPaticipant.endpointInfo.path, "Groups/groupsForParticipants", "Path Not Correct!")
        XCTAssertEqual(groupsPaticipant.endpointInfo.requestMethod, .get, "Request Method Not Correct!")
        XCTAssertNotNil(groupsPaticipant.endpointInfo.parameters, "Value Should Not Be Nil!")
        XCTAssertTrue(groupsPaticipant.endpointInfo.parameterEncoding is URLEncoding, "Encoding Not Correct!")
        XCTAssertTrue(groupsPaticipant.endpointInfo.requiresAuthorization, "Value Should Be True!")
    }
}
