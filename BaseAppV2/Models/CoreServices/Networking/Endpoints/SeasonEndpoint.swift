//
//  SeasonEndpoint.swift
//  BaseAppV2
//
//  Created by Michael Sevy on 5/30/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireCoreData

/**
    An enum that conforms to `BaseEndpoint`. It defines
    endpoints that would be used for the Season class.
 */
enum SeasonEndpoint: BaseEndpoint {
    case fetch(seasonId: Int16)
    case fetchScores(seasonId: Int16)

    var endpointInfo: BaseEndpointInfo {
        let path: String
        let requestMethod: Alamofire.HTTPMethod
        let parameters: Alamofire.Parameters?
        let parameterEncoding: Alamofire.ParameterEncoding?
        let requiresAuthorization: Bool
        switch self {
        case let .fetch(seasonId):
            path = "Seasons\(seasonId)"
            requestMethod = .get
            parameters = nil
            parameterEncoding = nil
            requiresAuthorization = true
            break
        case let .fetchScores(seasonId):
            path = "Seasons/\(seasonId)/scores"
            requestMethod = .get
            parameters = nil
            parameterEncoding = nil
            requiresAuthorization = true
            break
        }
        return BaseEndpointInfo(path: path, requestMethod: requestMethod, parameters: parameters, parameterEncoding: parameterEncoding, requiresAuthorization: requiresAuthorization)
    }
}
