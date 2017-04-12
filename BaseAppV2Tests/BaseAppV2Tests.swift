//
//  BaseAppV2Tests.swift
//  BaseAppV2Tests
//
//  Created by Emanuel  Guerrero on 2/28/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
import OHHTTPStubs
@testable import BaseAppV2

class BaseAppV2Tests: XCTestCase {
    
    // MARK: - Setup & Tear Down
    override func setUp() {
        super.setUp()
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/v1/users/me") && isMethodGET(), response: { _ in
            guard let path = OHPathForFile("currentuser.json", type(of: self)) else {
                preconditionFailure("Could Not Find Test File!")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/v1/users/210") && isMethodPATCH(), response: { _ in
            guard let path = OHPathForFile("updateuser.json", type(of: self)) else {
                preconditionFailure("Could Not Find Test File!")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/v1/login") && isMethodPOST(), response: { _ in
            guard let path = OHPathForFile("loginuser.json", type(of: self)) else {
                preconditionFailure("Could Not Find Test File!")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/v1/register") && isMethodPOST(), response: { _ in
            guard let path = OHPathForFile("registeruser.json", type(of: self)) else {
                preconditionFailure("Could Not Find Test File!")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/v1/social-auth") && isMethodPOST(), response: { _ in
            guard let path = OHPathForFile("loginuseroauth.json", type(of: self)) else {
                preconditionFailure("Could Not Find Test File!")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/v1/social-auth") && isMethodPOST()) { (request: URLRequest) -> OHHTTPStubsResponse in
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
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/v1/forgot-password") && isMethodPOST(), response: { _ in
            return OHHTTPStubsResponse(jsonObject: ["key":"value"], statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/v1/forgot-password/reset") && isMethodPOST(), response: { _ in
            return OHHTTPStubsResponse(jsonObject: ["key":"value"], statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/v1/users") && isMethodGET(), response: { _ in
            guard let path = OHPathForFile("userlistpage1.json", type(of: self)) else {
                preconditionFailure("Could Not Find Test File!")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/v1/users") && isMethodGET() && containsQueryParams(["page": "2"]), response: { _ in
            guard let path = OHPathForFile("userlistpage2.json", type(of: self)) else {
                preconditionFailure("Could Not Find Test File!")
            }
            return OHHTTPStubsResponse(fileAtPath: path, statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/v1/change-email") && isMethodPOST(), response: { _ in
            return OHHTTPStubsResponse(jsonObject: ["key":"value"], statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/v1/change-email/1/confirm") && isMethodPOST(), response: { _ in
            return OHHTTPStubsResponse(jsonObject: ["key":"value"], statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/v1/change-email/1/verify") && isMethodPOST(), response: { _ in
            return OHHTTPStubsResponse(jsonObject: ["key":"value"], statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/v1/users/change-password") && isMethodPOST(), response: { _ in
            return OHHTTPStubsResponse(jsonObject: ["key":"value"], statusCode: 200, headers: ["Content-Type":"application/json"])
        })
        stub(condition: isHost((URL(string: ConfigurationManager.shared.apiUrl!)?.host)!) && isPath("/v1/users/1/confirm-email") && isMethodPOST(), response: { _ in
            return OHHTTPStubsResponse(jsonObject: ["key":"value"], statusCode: 200, headers: ["Content-Type":"application/json"])
        })
    }
    
    override func tearDown() {
        super.tearDown()
        OHHTTPStubs.removeAllStubs()
    }
}
