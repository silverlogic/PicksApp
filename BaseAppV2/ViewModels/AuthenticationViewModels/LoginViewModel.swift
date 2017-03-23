//
//  LoginViewModel.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/9/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A protocol for defining state and behavior
    for login.
*/
protocol LoginViewModelProtocol {
    
    // MARK: - Instance Attributes
    var email: String { get set }
    var password: String { get set }
    var facebookRedirectUri: String { get }
    var facebookOAuthUrl: URL { get }
    var linkedInRedirectUri: String { get }
    var linkedInOAuthUrl: URL { get }
    var redirectUrlWithQueryParameters: URL? { get set }
    var loginError: DynamicBinder<BaseError?> { get }
    var loginSuccess: DynamicBinder<Bool> { get }
    
    
    // MARK: - Instance Methods
    func loginWithEmail()
    func loginWithFacebook(email: String?)
    func loginWithLinkedIn(email: String?)
    // @TODO: Add method declarations for Twitter
}


/**
    A class that conforms to `LoginViewModelProtocol`
    and implements it.
*/
final class LoginViewModel: LoginViewModelProtocol {
    
    // MARK: - LoginViewModelProtocol Attributes
    var email: String
    var password: String
    var facebookRedirectUri: String
    var facebookOAuthUrl: URL
    var linkedInRedirectUri: String
    var linkedInOAuthUrl: URL
    var redirectUrlWithQueryParameters: URL?
    var loginError: DynamicBinder<BaseError?>
    var loginSuccess: DynamicBinder<Bool>
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `LoginViewModel`.
    init() {
        email = ""
        password = ""
        facebookRedirectUri = ConfigurationManager.shared.facebookRedirectUri
        facebookOAuthUrl = ConfigurationManager.shared.facebookOAuthUrl!
        linkedInRedirectUri = ConfigurationManager.shared.linkedInRedirectUri
        linkedInOAuthUrl = ConfigurationManager.shared.linkedInOAuthUrl!
        redirectUrlWithQueryParameters = nil
        loginError = DynamicBinder(nil)
        loginSuccess = DynamicBinder(false)
    }
    
    
    // MARK: LoginViewModelProtocol Methods
    func loginWithEmail() {
        if email.isEmpty || password.isEmpty {
            loginError.value = BaseError.fieldsEmpty
            return
        }
        AuthenticationManager.shared.login(email: email, password: password, success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loginSuccess.value = true
            NotificationCenter.default.post(name: .UserLoggedIn, object: nil)
        }) {  [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            strongSelf.loginError.value = error
        }
    }
    
    func loginWithFacebook(email: String?) {
        guard let urlWithQueryParameters = redirectUrlWithQueryParameters else {
            loginError.value = BaseError.generic
            return
        }
        AuthenticationManager.shared.loginWithOAuth2(redirectUrlWithQueryParameters: urlWithQueryParameters, redirectUri: facebookRedirectUri, provider: .facebook, email: email, success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loginSuccess.value = true
            NotificationCenter.default.post(name: .UserLoggedIn, object: nil)
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            if error.statusCode == 103 {
                strongSelf.loginError.value = BaseError.emailNeededForOAuthFacebook
                return
            }
            strongSelf.loginError.value = error
        }
    }
    
    func loginWithLinkedIn(email: String?) {
        guard let urlWithQueryParameters = redirectUrlWithQueryParameters else {
            loginError.value = BaseError.generic
            return
        }
        AuthenticationManager.shared.loginWithOAuth2(redirectUrlWithQueryParameters: urlWithQueryParameters, redirectUri: linkedInRedirectUri, provider: .linkedIn, email: email, success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loginSuccess.value = true
            NotificationCenter.default.post(name: .UserLoggedIn, object: nil)
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            if error.statusCode == 103 {
                strongSelf.loginError.value = BaseError.emailNeededForOAuthLinkedIn
                return
            }
            strongSelf.loginError.value = error
        }
    }
}
