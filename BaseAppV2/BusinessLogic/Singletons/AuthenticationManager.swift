//
//  AuthenticationManager.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/8/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import PromiseKit

/**
    A singleton responsible for login, signup,
    and social authentication operations.
*/
final class AuthenticationManager {
    
    // MARK: - Shared Instance
    static let shared = AuthenticationManager()
    
    
    // MARK: - Initializers
    
    /**
        Initializes a shared instance of `AuthenticationManager`.
    */
    private init() {}
}


// MARK: - Public Instance Methods
extension AuthenticationManager {
    
    /**
        Logs in a user with a given email and password.
     
        - Parameters:
            - email: A `String` representing the email of the user.
            - password: A `String` representing the password of the user.
            - success: A closure that gets invoked when logging in a user
                       was successful.
            - failure: A closure that gets invoked when logging in a user
                       failed. Passes an `APIError` object that contains the
                       error that occured.
    */
    func login(email: String, password: String, success: @escaping () -> Void, failure: @escaping (_ error: BaseError) -> Void) {
        let dispatchQueue = DispatchQueue.global(qos: .userInteractive)
        dispatchQueue.async {
            let networkClient = NetworkClient(baseUrl: ConfigurationManager.shared.apiUrl!, manageObjectContext: CoreDataStack.shared.managedObjectContext)
            networkClient.enqueue(AuthenticationEndpoint.login(email: email, password: password))
            .then(on: dispatchQueue, execute: { (loginResponse: LoginResponse) in
                SessionManager.shared.authorizationToken = loginResponse.token
                return networkClient.enqueue(AuthenticationEndpoint.currentUser)
            })
            .then(on: dispatchQueue, execute: { (user: User) -> Void in
                SessionManager.shared.currentUser = user
            })
            .then(on: DispatchQueue.main, execute: {
                success()
            })
            .catchAPIError(on: DispatchQueue.main, policy: .allErrors, execute: { (error: BaseError) in
                failure(error)
            })
        }
    }
    
    /**
        Signs up a new user.
     
        - Parameters:
            - signupInfo: A `SignUpInfo` representing the information needed for
                          signup.
            - updateInfo: A `UpdateInfo` representing the information needed for
                          updating the user once they have logged in and recieved
                          an authorization token.
            - success: A closure that gets invoked when signing up the user was successful.
            - failure: A closure that gets invoked when signing up the user failed. Passes
                       an `APIError` object that contains the error that occured.
    */
    func signup(_ signupInfo: SignUpInfo, updateInfo: UpdateInfo, success: @escaping () -> Void, failure: @escaping (_ error: BaseError) -> Void) {
        let dispatchQueue = DispatchQueue.global(qos: .userInteractive)
        dispatchQueue.async {
            let networkClient = NetworkClient(baseUrl: ConfigurationManager.shared.apiUrl!, manageObjectContext: CoreDataStack.shared.managedObjectContext)
            networkClient.enqueue(AuthenticationEndpoint.signUp(signUpInfo: signupInfo))
            .then(on: dispatchQueue, execute: { (user: User) in
                SessionManager.shared.currentUser = user
                return networkClient.enqueue(AuthenticationEndpoint.login(email: signupInfo.email, password: signupInfo.password))
            })
            .then(on: dispatchQueue, execute: { (loginResponse: LoginResponse) in
                SessionManager.shared.authorizationToken = loginResponse.token
                return networkClient.enqueue(AuthenticationEndpoint.update(updateInfo: updateInfo, userId: Int((SessionManager.shared.currentUser?.userId)!)))
            })
            .then(on: DispatchQueue.main, execute: { (user: User) -> Void in
                SessionManager.shared.currentUser = user
                success()
            })
            .catchAPIError(on: DispatchQueue.main, policy: .allErrors, execute: { (error: BaseError) in
                failure(error)
            })
        }
    }
}
