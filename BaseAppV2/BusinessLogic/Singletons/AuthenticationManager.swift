//
//  AuthenticationManager.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/8/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

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
    
    /**
        Logs in a user using OAuth2 authentication.
     
        ## Possible Errors
     
        1. When an email wasn't provided when logging into the provider
           or the provider doesn't give an email for the user, the user
           would be asked to provide an email. Then recall this method
           with the provided email.
        2. When an email given from the provider is already in use in the
           API, login can't continue and the user should be notified.
        3. When an invalid provider is given or the OAuth authorization
           code is incorrect, the user should be notified. This can occur
           if the token expired or the registered app id and/or redirect
           url used isn't the same as the one the API used.
        4. If the OAuth authorization code can't be parsed, the user should
           be notified.
     
        - Parameters:
            - redirectUrlWithQueryParameters: A `URL` representing the redirect url that
                                              the OAuth2 provider used. This would contain
                                              the OAuth authorization code in it as a query
                                              parameter.
            - redirectUri: A `String` representing the redirect uri registered for the
                           provider.
            - provider: An `OAuth2Provider` representing the type of provider used. This
                        determines how `redirectUrlWithQueryParameters` would be parsed.
            - email: A `String` representing the email of the user. This would be filled if
                     an email wasn't provided to the provider. `nil` can be passed as a
                     parameter.
            - success: A closure that gets invoked when logging in the user was successful.
            - failure: A closure that gets invoked when logging in the user failed. Passes
                       an `BaseError` object that contains the error that occured.
    */
    func loginWithOAuth2(redirectUrlWithQueryParameters: URL, redirectUri: String, provider: OAuth2Provider, email: String?, success: @escaping () -> Void, failure: @escaping (_ error: BaseError) -> Void) {
        let absoluteString = redirectUrlWithQueryParameters.absoluteString
        guard let range = absoluteString.range(of: "code=") else {
            failure(BaseError.generic)
            return
        }
        var newRange = range.upperBound
        var code = absoluteString.substring(from: newRange)
        if provider == .linkedIn {
            guard let linkedInRange = code.range(of: "&state=") else {
                failure(BaseError.generic)
                return
            }
            newRange = linkedInRange.lowerBound
            code = code.substring(to: newRange)
        }
        let oauth2Info = OAuth2Info(provider: provider, oauthCode: code, redirectUri: redirectUri, email: email, referralCodeOfReferrer: nil)
        let dispatchQueue = DispatchQueue.global(qos: .userInteractive)
        dispatchQueue.async {
            let networkClient = NetworkClient(baseUrl: ConfigurationManager.shared.apiUrl!, manageObjectContext: CoreDataStack.shared.managedObjectContext)
            networkClient.enqueue(AuthenticationEndpoint.oauth2(oauth2Info: oauth2Info))
            .then(on: dispatchQueue, execute: { (oauthResponse: OAuthResponse) in
                SessionManager.shared.authorizationToken = oauthResponse.token
                return networkClient.enqueue(AuthenticationEndpoint.currentUser)
            })
            .then(on: DispatchQueue.main, execute: { (user: User) -> Void in
                SessionManager.shared.currentUser = user
                success()
            })
            .catchAPIError(on: DispatchQueue.main, policy: .allErrors, execute: { (error: BaseError) in
                if error.errorDescription == OAuthErrorConstants.noEmailProvided {
                    failure(BaseError.emailNeededForOAuth)
                } else if error.errorDescription == OAuthErrorConstants.emailAlreadyInUse {
                    failure(BaseError.emailAlreadyInUseForOAuth)
                } else if error.errorDescription == OAuthErrorConstants.invalidCredentials || error.errorDescription == OAuthErrorConstants.invalidProvider {
                    failure(BaseError.generic)
                } else {
                    failure(error)
                }
            })
        }
    }
}
