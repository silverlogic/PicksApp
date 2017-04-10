//
//  UserEndpoint.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/30/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireCoreData

/**
    An enum that conforms to `BaseEndpoint`. It defines
    endpoints that would be used for retreving users.
*/
enum UserEndpoint: BaseEndpoint {
    case user(userId: Int)
    case users(pagination: Pagination?)
    
    var endpointInfo: BaseEndpointInfo {
        let path: String
        let requestMethod: Alamofire.HTTPMethod
        let parameters: Alamofire.Parameters?
        let parameterEncoding: Alamofire.ParameterEncoding?
        let requiresAuthorization: Bool
        switch self {
        case let .user(userId):
            path = "users/\(userId)"
            requestMethod = .get
            parameters = nil
            parameterEncoding = nil
            requiresAuthorization = false
            break
        case let .users(pagination):
            path = "users"
            requestMethod = .get
            if let next = pagination?.next {
                parameters = ["page": next]
            } else {
                parameters = nil
            }
            parameterEncoding = nil
            requiresAuthorization = false
            break
        }
        return BaseEndpointInfo(path: path, requestMethod: requestMethod, parameters: parameters, parameterEncoding: parameterEncoding, requiresAuthorization: requiresAuthorization)
    }
}
