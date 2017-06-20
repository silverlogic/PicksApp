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
protocol LoginViewModelProtocol: class {
    
    // MARK: - Instance Attributes
    var email: String { get set }
    var password: String { get set }
    var facebookRedirectUri: String { get }
    var facebookOAuthUrl: URL { get }
    var linkedInRedirectUri: String { get }
    var linkedInOAuthUrl: URL { get }
    var twitterRedirectUri: String { get }
    var twitterOAuthUrl: DynamicBinderInterface<URL?> { get }
    var redirectUrlWithQueryParameters: URL? { get set }
    var loginError: DynamicBinderInterface<BaseError?> { get }
    var loginSuccess: DynamicBinderInterface<Bool> { get }
    var oauthStep1Error: DynamicBinderInterface<BaseError?> { get }

    
    // MARK: - Instance Methods
    func loginWithEmail()
    func loginWithFacebook(email: String?)
    func loginWithLinkedIn(email: String?)
    func oauth1InfoForTwitter()
    func loginWithTwitter(email: String?)
}


/**
    A `ViewModelsManager` class extension for `LoginViewModelProtocol`.
 */
extension ViewModelsManager {
    
    /**
        Returns an instance conforming to `LoginViewModelProtocol`.
     
        - Return: an instance conforming to `LoginViewModelProtocol`.
     */
    class func loginViewModel() -> LoginViewModelProtocol {
        return LoginViewModel()
    }
}


/**
    A class that conforms to `LoginViewModelProtocol`
    and implements it.
*/
fileprivate final class LoginViewModel: LoginViewModelProtocol {
    
    // MARK: - LoginViewModelProtocol Attributes
    var email: String
    var password: String
    var facebookRedirectUri: String
    var facebookOAuthUrl: URL
    var linkedInRedirectUri: String
    var linkedInOAuthUrl: URL
    var twitterRedirectUri: String
    var twitterOAuthUrl: DynamicBinderInterface<URL?> {
        return twitterOAuthUrlBinder.interface
    }
    var redirectUrlWithQueryParameters: URL?
    var loginError: DynamicBinderInterface<BaseError?> {
        return loginErrorBinder.interface
    }
    var loginSuccess: DynamicBinderInterface<Bool> {
        return loginSuccessBinder.interface
    }
    var oauthStep1Error: DynamicBinderInterface<BaseError?> {
        return oauthStep1ErrorBinder.interface
    }
    
    
    // MARK: - Private Instance Attributes
    private var twitterOAuth1Step1Resonse: OAuth1Step1Response?
    private var twitterOAuthUrlBinder: DynamicBinder<URL?>
    private var loginErrorBinder: DynamicBinder<BaseError?>
    private var loginSuccessBinder: DynamicBinder<Bool>
    private var oauthStep1ErrorBinder: DynamicBinder<BaseError?>

    
    // MARK: - Initializers
    
    /// Initializes an instance of `LoginViewModel`.
    init() {
        email = ""
        password = ""
        facebookRedirectUri = ConfigurationManager.shared.facebookRedirectUri
        facebookOAuthUrl = ConfigurationManager.shared.facebookOAuthUrl!
        linkedInRedirectUri = ConfigurationManager.shared.linkedInRedirectUri
        linkedInOAuthUrl = ConfigurationManager.shared.linkedInOAuthUrl!
        twitterRedirectUri = ConfigurationManager.shared.twitterRedirectUri
        twitterOAuthUrlBinder = DynamicBinder(nil)
        redirectUrlWithQueryParameters = nil
        loginErrorBinder = DynamicBinder(nil)
        loginSuccessBinder = DynamicBinder(false)
        oauthStep1ErrorBinder = DynamicBinder(nil)
    }
    
    
    // MARK: LoginViewModelProtocol Methods
    func loginWithEmail() {
        if email.isEmpty || password.isEmpty {
            loginErrorBinder.value = BaseError.fieldsEmpty
            return
        }
        AuthenticationManager.shared.login(email: email, password: password, success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loginSuccessBinder.value = true
            NotificationCenter.default.post(name: .UserLoggedIn, object: nil)
        }) {  [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            strongSelf.loginErrorBinder.value = error
        }
    }

    func loginWithFacebook(email: String?) {
        guard let urlWithQueryParameters = redirectUrlWithQueryParameters else {
            loginErrorBinder.value = BaseError.generic
            return
        }
        AuthenticationManager.shared.loginWithOAuth2(redirectUrlWithQueryParameters: urlWithQueryParameters, redirectUri: facebookRedirectUri, provider: .facebook, email: email, success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loginSuccessBinder.value = true
            NotificationCenter.default.post(name: .UserLoggedIn, object: nil)
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            if error.statusCode == 103 {
                strongSelf.loginErrorBinder.value = BaseError.emailNeededForOAuthFacebook
                return
            }
            strongSelf.loginErrorBinder.value = error
        }
    }

    func loginWithLinkedIn(email: String?) {
        guard let urlWithQueryParameters = redirectUrlWithQueryParameters else {
            loginErrorBinder.value = BaseError.generic
            return
        }
        AuthenticationManager.shared.loginWithOAuth2(redirectUrlWithQueryParameters: urlWithQueryParameters, redirectUri: linkedInRedirectUri, provider: .linkedIn, email: email, success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loginSuccessBinder.value = true
            NotificationCenter.default.post(name: .UserLoggedIn, object: nil)
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            if error.statusCode == 103 {
                strongSelf.loginErrorBinder.value = BaseError.emailNeededForOAuthLinkedIn
                return
            }
            strongSelf.loginErrorBinder.value = error
        }
    }
    
    func oauth1InfoForTwitter() {
        AuthenticationManager.shared.oauth1Step1(redirectUri: twitterRedirectUri, provider: .twitter, success: { [weak self] (response: OAuth1Step1Response) in
            guard let strongSelf = self else { return }
            strongSelf.twitterOAuth1Step1Resonse = response
            let escapedString = response.oauthToken.utf8
            let twitterOAuthUrl = URL(string: "https://api.twitter.com/oauth/authenticate?oauth_token=\(escapedString)")
            strongSelf.twitterOAuthUrlBinder.value = twitterOAuthUrl
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            strongSelf.oauthStep1ErrorBinder.value = error
        }
    }
    
    func loginWithTwitter(email: String?) {
        guard let urlWithQueryParameters = redirectUrlWithQueryParameters,
              let oauth1Step1Resonse = twitterOAuth1Step1Resonse else {
            loginErrorBinder.value = BaseError.generic
            return
        }
        AuthenticationManager.shared.loginWithOAuth1(redirectUrlWithQueryParameters: urlWithQueryParameters, provider: .twitter, oauth1Response: oauth1Step1Resonse, email: email, success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.loginSuccessBinder.value = true
            NotificationCenter.default.post(name: .UserLoggedIn, object: nil)
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            if error.statusCode == 103 {
                strongSelf.loginErrorBinder.value = BaseError.emailNeededForOAuthTwitter
                return
            }
            strongSelf.loginErrorBinder.value = error
        }
    }
}
