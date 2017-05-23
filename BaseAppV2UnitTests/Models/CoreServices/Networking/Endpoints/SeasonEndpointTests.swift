//
//  SeasonEndpointTests.swift
//  BaseAppV2
//
//  Created by Michael Sevy on 6/1/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
import Alamofire
@testable import BaseAppV2

final class SeasonEndpointTests: BaseAppV2UnitTests {

    // MARK: - Functional Tests
    func testFetchScores() {
        let seasonEndpoint = SeasonEndpoint.fetchScores(seasonId: 117)
        XCTAssertNotNil(seasonEndpoint, "Value Should Not Be Nil!")
        XCTAssertEqual(seasonEndpoint.endpointInfo.path, "Seasons/117/scores", "Path Not Correct!")
        XCTAssertEqual(seasonEndpoint.endpointInfo.requestMethod, .get, "Request Mehod Not Correct!")
        XCTAssertNil(seasonEndpoint.endpointInfo.parameters, "Parameters Should be Nil!")
        XCTAssertTrue(seasonEndpoint.endpointInfo.parameterEncoding is URLEncoding, "Encoding Not Correct")
        XCTAssertTrue(seasonEndpoint.endpointInfo.requiresAuthorization, "Value Should Be True!")
    }
}
