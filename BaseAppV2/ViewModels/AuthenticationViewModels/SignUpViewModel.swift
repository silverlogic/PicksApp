//
//  SignUpViewModel.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/10/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A protocol for defining state and behavior for
    signup with email.
*/
protocol SignUpViewModelProtocol {
    
    // MARK: - Instance Attributes
    var email: String { get set }
    var password: String { get set }
    var confirmPassword: String { get set }
    var firstName: String { get set }
    var lastName: String { get set }
    var signUpError: DynamicBinder<BaseError?> { get }
    var signUpSuccess: DynamicBinder<Bool> { get }
    
    
    // MARK: - Instance Methods
    func signup()
    func validateEmail()
    func validatePassword()
}


/**
    A class that conforms to `SignUpViewModelProtocol` and
    implements it.
*/
final class SignUpViewModel: SignUpViewModelProtocol {
    
    // MARK: - SignUpViewModelProtocol Attributes
    var email: String
    var password: String
    var confirmPassword: String
    var firstName: String
    var lastName: String
    var signUpError: DynamicBinder<BaseError?>
    var signUpSuccess: DynamicBinder<Bool>
    
    
    // MARK: Initializers
    
    /// Initializes an instance of `SignUpViewModel`
    init() {
        email = ""
        password = ""
        confirmPassword = ""
        firstName = ""
        lastName = ""
        signUpError = DynamicBinder(nil)
        signUpSuccess = DynamicBinder(false)
    }
    
    
    // MARK: - SignUpViewModelProtocol Methods
    func signup() {
        if firstName.isEmpty || lastName.isEmpty {
            signUpError.value = BaseError.fieldsEmpty
            return
        }
        let signupInfo = SignUpInfo(email: email, password: password, referralCodeOfReferrer: nil)
        let updateInfo = UpdateInfo(referralCodeOfReferrer: nil, avatarBaseString: nil, firstName: firstName, lastName: lastName)
        AuthenticationManager.shared.signup(signupInfo, updateInfo: updateInfo, success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.signUpSuccess.value = true
            NotificationCenter.default.post(name: .UserLoggedIn, object: nil)
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            strongSelf.signUpError.value = error
        }
    }
    
    func validateEmail() {
        if email.isEmpty {
            signUpError.value = BaseError.fieldsEmpty
            return
        }
        signUpSuccess.value = true
    }
    
    func validatePassword() {
        if password.isEmpty || confirmPassword.isEmpty {
            signUpError.value = BaseError.fieldsEmpty
            return
        }
        if password != confirmPassword {
            signUpError.value = BaseError.passwordsDoNotMatch
            return
        }
        signUpSuccess.value = true
    }
}
