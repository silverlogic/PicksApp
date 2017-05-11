//
//  BaseAppV2UnitTests.swift
//  BaseAppV2UnitTests
//
//  Created by Emanuel  Guerrero on 4/24/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import BaseAppV2

class BaseAppV2UnitTests: XCTestCase {
    
    // MARK: - Setup & Tear Down
    override func setUp() {
        super.setUp()
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/api/PicksUsers/me") && isMethodGET(), response: { _ in
            guard let path = OHPathForFile("currentuser.json", type(of: self)) else {
                preconditionFailure("Could Not Find Test File!")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/api/users/210") && isMethodPATCH(), response: { _ in
            guard let path = OHPathForFile("updateuser.json", type(of: self)) else {
                preconditionFailure("Could Not Find Test File!")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/api/login") && isMethodPOST(), response: { _ in
            guard let path = OHPathForFile("loginuser.json", type(of: self)) else {
                preconditionFailure("Could Not Find Test File!")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/api/register") && isMethodPOST(), response: { _ in
            guard let path = OHPathForFile("registeruser.json", type(of: self)) else {
                preconditionFailure("Could Not Find Test File!")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/api/social-auth") && isMethodPOST(), response: { _ in
            guard let path = OHPathForFile("loginuseroauth.json", type(of: self)) else {
                preconditionFailure("Could Not Find Test File!")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/api/social-auth") && isMethodPOST()) { (request: URLRequest) -> OHHTTPStubsResponse in
            let nsUrlRequest = request as NSURLRequest
            let requestBody = nsUrlRequest.ohhttpStubs_HTTPBody()!
            let bodyString = String(data: requestBody, encoding: .utf8)!
            if bodyString == "{\"provider\":\"twitter\",\"redirect_uri\":\"https:\\/\\/app.baseapp.tsl.io\\/\"}" {
                guard let path = OHPathForFile("oauth1response.json", type(of: self)) else {
                    preconditionFailure("Could Not Find Test File!")
                }
                return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type":"application/json"])
            }
            guard let path = OHPathForFile("loginuseroauth.json", type(of: self)) else {
                preconditionFailure("Could Not Find Test File!")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type":"application/json"])
        }
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/api/forgot-password") && isMethodPOST(), response: { _ in
            return OHHTTPStubsResponse(jsonObject: ["key":"value"], statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/api/forgot-password/reset") && isMethodPOST(), response: { _ in
            return OHHTTPStubsResponse(jsonObject: ["key":"value"], statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/api/users") && isMethodGET(), response: { _ in
            guard let path = OHPathForFile("userlistpage1.json", type(of: self)) else {
                preconditionFailure("Could Not Find Test File!")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/api/users") && isMethodGET() && containsQueryParams(["page": "2"]), response: { _ in
            guard let path = OHPathForFile("userlistpage2.json", type(of: self)) else {
                preconditionFailure("Could Not Find Test File!")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/api/change-email") && isMethodPOST(), response: { _ in
            return OHHTTPStubsResponse(jsonObject: ["key":"value"], statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/api/change-email/1/confirm") && isMethodPOST(), response: { _ in
            return OHHTTPStubsResponse(jsonObject: ["key":"value"], statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/api/change-email/1/verify") && isMethodPOST(), response: { _ in
            return OHHTTPStubsResponse(jsonObject: ["key":"value"], statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/api/users/change-password") && isMethodPOST(), response: { _ in
            return OHHTTPStubsResponse(jsonObject: ["key":"value"], statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/api/users/1/confirm-email") && isMethodPOST(), response: { _ in
            return OHHTTPStubsResponse(jsonObject: ["key":"value"], statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/api/PicksUsers/login-facebook") && isMethodPOST(), response: { _ in
            guard let path = OHPathForFile("loginuser.json", type(of: self)) else {
                preconditionFailure("Could Not Find Test File!")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/api/PicksUsers/signup-facebook") && isMethodPOST(), response: { _ in
            guard let path = OHPathForFile("loginuser.json", type(of: self)) else {
                preconditionFailure("Could Not Find Test File!")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/api/Groups") && isMethodPOST(), response: { _ in
            return OHHTTPStubsResponse(jsonObject: ["key":"value"], statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/api/Groups/1/join") && isMethodPOST(), response: { _ in
            return OHHTTPStubsResponse(jsonObject: ["key":"value"], statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/api/Groups/groupsForCreator") && isMethodGET(), response: { _ in
            guard let path = OHPathForFile("grouplistforuser.json", type(of: self)) else {
                preconditionFailure("Could Not Find Test File!")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/api/Groups/groupsForParticipants") && isMethodGET(), response: { _ in
            guard let path = OHPathForFile("grouplistparticipants.json", type(of: self)) else {
                preconditionFailure("Could Not Find Test File!")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type":"application/json"])
        })
    }
    
    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }
}
