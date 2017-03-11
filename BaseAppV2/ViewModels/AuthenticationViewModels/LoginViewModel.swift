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
    var loginError: DynamicBinder<BaseError?> { get }
    var loginSuccess: DynamicBinder<Bool> { get }
    
    
    // MARK: - Instance Methods
    func loginWithEmail()
    // @TODO: Add method declarations for social auth once implemented.
}


/**
    A class that conforms to `LoginViewModelProtocol`
    and implements it.
*/
final class LoginViewModel: LoginViewModelProtocol {
    
    // MARK: - LoginViewModelProtocol Attributes
    var email: String
    var password: String
    var loginError: DynamicBinder<BaseError?>
    var loginSuccess: DynamicBinder<Bool>
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `LoginViewModel`.
    init() {
        email = ""
        password = ""
        loginError = DynamicBinder(nil)
        loginSuccess = DynamicBinder(false)
    }
    
    
    // MARK: LoginViewModelProtocol Methods
    func loginWithEmail() {
        if email.isEmpty || password.isEmpty {
            loginError.value = BaseError(statusCode: 101, errorDescription: "")
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
}
