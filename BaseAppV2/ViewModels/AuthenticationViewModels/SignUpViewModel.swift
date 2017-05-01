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
protocol SignUpViewModelProtocol: class {
    
    // MARK: - Instance Attributes
    var email: String { get set }
    var password: String { get set }
    var confirmPassword: String { get set }
    var firstName: String { get set }
    var lastName: String { get set }
    var signUpError: DynamicBinderInterface<BaseError?> { get }
    var signUpSuccess: DynamicBinderInterface<Bool> { get }
    
    
    // MARK: - Instance Methods
    func signup()
    func validateEmail()
    func validatePassword()
}


/**
    A `ViewModelsManager` class extension for `SignUpViewModelProtocol`.
 */
extension ViewModelsManager {
    
    /**
        Returns an instance conforming to `SignUpViewModelProtocol`.
     
        - Return: an instance conforming to `SignUpViewModelProtocol`.
     */
    class func signUpViewModel() -> SignUpViewModelProtocol {
        return SignUpViewModel()
    }
}


/**
    A class that conforms to `SignUpViewModelProtocol` and
    implements it.
*/
fileprivate final class SignUpViewModel: SignUpViewModelProtocol {
    
    // MARK: - SignUpViewModelProtocol Attributes
    var email: String
    var password: String
    var confirmPassword: String
    var firstName: String
    var lastName: String
    var signUpError: DynamicBinderInterface<BaseError?> {
        return signUpErrorBinder.interface
    }
    var signUpSuccess: DynamicBinderInterface<Bool> {
        return signUpSuccessBinder.interface
    }
    
    
    // MARK: - Private Instance Attributes
    fileprivate var signUpErrorBinder: DynamicBinder<BaseError?>
    fileprivate var signUpSuccessBinder: DynamicBinder<Bool>
    
    
    // MARK: Initializers
    
    /// Initializes an instance of `SignUpViewModel`
    init() {
        email = ""
        password = ""
        confirmPassword = ""
        firstName = ""
        lastName = ""
        signUpErrorBinder = DynamicBinder(nil)
        signUpSuccessBinder = DynamicBinder(false)
    }
    
    
    // MARK: - SignUpViewModelProtocol Methods
    func signup() {
        if firstName.isEmpty || lastName.isEmpty {
            signUpErrorBinder.value = BaseError.fieldsEmpty
            return
        }
        let signupInfo = SignUpInfo(email: email, password: password, referralCodeOfReferrer: nil)
        let updateInfo = UpdateInfo(referralCodeOfReferrer: nil, avatarBaseString: nil, firstName: firstName, lastName: lastName)
        AuthenticationManager.shared.signup(signupInfo, updateInfo: updateInfo, success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.signUpSuccessBinder.value = true
            NotificationCenter.default.post(name: .ShowTutorial, object: nil)
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            strongSelf.signUpErrorBinder.value = error
        }
    }
    
    func validateEmail() {
        if email.isEmpty {
            signUpErrorBinder.value = BaseError.fieldsEmpty
            return
        }
        signUpSuccessBinder.value = true
    }
    
    func validatePassword() {
        if password.isEmpty || confirmPassword.isEmpty {
            signUpErrorBinder.value = BaseError.fieldsEmpty
            return
        }
        if password != confirmPassword {
            signUpErrorBinder.value = BaseError.passwordsDoNotMatch
            return
        }
        signUpSuccessBinder.value = true
    }
}
