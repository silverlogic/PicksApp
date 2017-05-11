//
//  GroupEndpoint.swift
//  BaseAppV2
//
//  Created by Michael Sevy on 5/15/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireCoreData

/**
    An enum that conforms to `BaseEndpoint`. It defines
    endpoints that would be used for the Group class.
 */
enum GroupEndpoint: BaseEndpoint {
    case post(groupName: String, creator: User, isPrivate: Bool)
    case join(groupId: Int16, user: User)
    case groupsCreator(creatorId: Int16, isPrivate: Bool)
    case groupsParticipant(participantId: Int16?, isPrivate: Bool)

    var endpointInfo: BaseEndpointInfo {
        let path: String
        let requestMethod: Alamofire.HTTPMethod
        let parameters: Alamofire.Parameters?
        let parameterEncoding: Alamofire.ParameterEncoding?
        let requiresAuthorization: Bool
        switch self {
        case let .post(groupName, creatorId, isPrivate):
            path = "Groups"
            requestMethod = .post
            parameters = ["name": groupName, "creator": creatorId.userId, "isPrivate": isPrivate]
            parameterEncoding = JSONEncoding()
            requiresAuthorization = true
            break
        case let .join(groupId, user):
            path = "Groups/\(groupId)/join"
            requestMethod = .post
            parameters = ["userId": user.userId];
            parameterEncoding = JSONEncoding()
            requiresAuthorization = true
            break
        case let .groupsCreator(creatorId, isPrivate):
            path = "Groups/groupsForCreator"
            requestMethod = .get
            parameters = ["creatorId": creatorId, "isPrivate": isPrivate]
            parameterEncoding = URLEncoding()
            requiresAuthorization = true
            break
        case let .groupsParticipant(participantId, isPrivate):
            path = "Groups/groupsForParticipants"
            requestMethod = .get
            parameters = ["participantId": participantId ?? 0, "isPrivate": isPrivate]
            parameterEncoding = URLEncoding()
            requiresAuthorization = true
            break
        }
        return BaseEndpointInfo(path: path, requestMethod: requestMethod, parameters: parameters, parameterEncoding: parameterEncoding, requiresAuthorization: requiresAuthorization)
    }
}
