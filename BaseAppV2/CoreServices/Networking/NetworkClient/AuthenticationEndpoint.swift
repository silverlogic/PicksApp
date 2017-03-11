//
//  AuthenticationEndpoint.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/8/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireCoreData

/**
    An enum that conforms to `BaseEndpoint`. It defines
    endpoints that would be used for authentication.
*/
enum AuthenticationEndpoint: BaseEndpoint {
    case login(email: String, password: String)
    case signUp(signUpInfo: SignUpInfo)
    case update(updateInfo: UpdateInfo, userId: Int)
    case currentUser
    
    var endpointInfo: BaseEndpointInfo {
        let path: String
        let requestMethod: Alamofire.HTTPMethod
        let parameters: Alamofire.Parameters?
        let parameterEncoding: Alamofire.ParameterEncoding?
        let requiresAuthorization: Bool
        switch self {
        case let .login(email, password):
            path = "login"
            requestMethod = .post
            parameters = ["email": email, "password": password]
            parameterEncoding = JSONEncoding()
            requiresAuthorization = false
            break
        case let .signUp(signUpInfo):
            path = "register"
            requestMethod = .post
            parameters = signUpInfo.parameters
            parameterEncoding = JSONEncoding()
            requiresAuthorization = false
            break
        case let .update(updateInfo, userId):
            path = "users/\(userId)"
            requestMethod = .patch
            parameters = updateInfo.parameters
            parameterEncoding = JSONEncoding()
            requiresAuthorization = true
            break
        case .currentUser:
            path = "users/me"
            requestMethod = .get
            parameters = nil
            parameterEncoding = nil
            requiresAuthorization = true
            break
        }
        return BaseEndpointInfo(path: path, requestMethod: requestMethod, parameters: parameters, parameterEncoding: parameterEncoding, requiresAuthorization: requiresAuthorization)
    }
}


/**
    A struct encapsulating what information is needed
    when registering a user.
*/
struct SignUpInfo {
    
    // MARK: - Public Instance Attributes
    let email: String
    let password: String
    let referralCodeOfReferrer: String?
    
    
    // MARK: - Getters & Setters
    var parameters: Alamofire.Parameters {
        var params: Parameters = [
            "email": email,
            "password": password
        ]
        if let referralCode = referralCodeOfReferrer {
            params["referral_code"] = referralCode
        }
        return params
    }
    
    
    // MARK: - Initializers
    
    /**
        Initializes an instance of `SignUpInfo`.
     
        - Parameters:
            - email: A `String` representing the email of the user.
            - password: A `String` representing the password that the
                        user would enter when logging in.
            - referralCodeOfReferrer: A `String` representing the referral
                                      code of another user that referred the
                                      current user to the application. `nil` can
                                      be passed if referral code isn't being used.
    */
    init(email: String, password: String, referralCodeOfReferrer: String?) {
        self.email = email
        self.password = password
        self.referralCodeOfReferrer = referralCodeOfReferrer
    }
}


/**
    A struct encapsulating what information is needed
    when updating a user.
*/
struct UpdateInfo {
    
    // MARK: - Public Instance Attributes
    let referralCodeOfReferrer: String?
    let avatarBaseString: String?
    let firstName: String
    let lastName: String
    
    
    // MARK: - Getters & Setters
    var parameters: Alamofire.Parameters {
        var params: Parameters = [
            "first_name": firstName,
            "last_name": lastName
        ]
        if let baseString = avatarBaseString {
            params["avatar"] = baseString
        }
        if let referralCode = referralCodeOfReferrer {
            params["referral_code"] = referralCode
        }
        return params
    }
    
    
    // MARK: - Initializers
    
    /**
        Initializes an instance of `UpdateInfo`.
     
        - Parameters:
            - referralCodeOfReferrer: A `String` representing the referral
                                      code of another user that referred the
                                      current user to the application. This is
                                      used when the user signs up through social
                                      authentication. In regular email signup, `nil`
                                      would be passed.
            - avatarBaseString: A `String` representing the base sixty four representation
                                of an image. `nil` can be passed if no imaged was selected
                                or changed.
            - firstName: A `String` representing the first name of the user.
            - lastName: A `String` representing the last name of the user.
    */
    init(referralCodeOfReferrer: String?, avatarBaseString: String?, firstName: String, lastName: String) {
        self.referralCodeOfReferrer = referralCodeOfReferrer
        self.avatarBaseString = avatarBaseString
        self.firstName = firstName
        self.lastName = lastName
    }
}


/**
    A struct representing the object sent back
    from the API when logging in a user
*/
struct LoginResponse: Wrapper {
    
    // MARK: - Public Instance Attributes
    var token: String!
    
    
    // MARK: - Initializers
    
    /**
        Initializes an instance of `LoginResponse`. This
        is used to conform to the protocol `Wrapper`.
    */
    init() {}
    
    
    // MARK: - Wrapper
    mutating func map(_ map: Map) {
        token <- map["token"]
    }
}
