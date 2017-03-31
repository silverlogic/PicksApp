//
//  ForgotPasswordViewModel.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/29/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A protocol for defining state and behavior
    for forgot password.
*/
protocol ForgotPasswordViewModelProtocol {
    
    // MARK: - Instance Attributes
    var email: String { get set }
    var newPassword: String { get set }
    var forgotPasswordError: DynamicBinder<BaseError?> { get }
    var forgotPasswordRequestSuccess: DynamicBinder<Bool> { get }
    var forgotPasswordResetSuccess: DynamicBinder<Bool> { get }
    
    
    // MARK: - Instance Methods
    func forgotPasswordRequest()
    func forgotPasswordReset()
    func cancelResetPassword()
}


/**
    A class that conforms to `ForgotPasswordViewModelProtocol`
    and implements it.
*/
final class ForgotPasswordViewModel: ForgotPasswordViewModelProtocol {
    
    // MARK: - ForgotPasswordViewModelProtocol Attributes
    var email: String
    var newPassword: String
    var forgotPasswordError: DynamicBinder<BaseError?>
    var forgotPasswordRequestSuccess: DynamicBinder<Bool>
    var forgotPasswordResetSuccess: DynamicBinder<Bool>
    
    
    // MARK: - Private Instance Methods
    private var token: String?
    
    
    // MARK: - Initializers
    
    /**
        Initializes an instance of `ForgotPasswordViewModel`.
     
        - Parameter token: A `String` representing the
                           verification token received
                           from a forgot password deep link.
                           `nil` can be passed as a parameter.
    */
    init(token: String?) {
        email = ""
        newPassword = ""
        forgotPasswordError = DynamicBinder(nil)
        forgotPasswordRequestSuccess = DynamicBinder(false)
        forgotPasswordResetSuccess = DynamicBinder(false)
        self.token = token
    }
    
    
    // MARK: - ForgotPasswordViewModelProtocol Methods
    func forgotPasswordRequest() {
        if email.isEmpty {
            forgotPasswordError.value = BaseError.fieldsEmpty
            return
        }
        AuthenticationManager.shared.forgotPasswordRequest(email: email, success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.forgotPasswordRequestSuccess.value = true
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            strongSelf.forgotPasswordError.value = error
        }
    }
    
    func forgotPasswordReset() {
        guard let verificationToken = token else { return }
        if newPassword.isEmpty {
            forgotPasswordError.value = BaseError.fieldsEmpty
            return
        }
        AuthenticationManager.shared.forgotPasswordReset(token: verificationToken, newPassword: newPassword, success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.forgotPasswordResetSuccess.value = true
            NotificationCenter.default.post(name: .UserLoggedOut, object: nil)
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            strongSelf.forgotPasswordError.value = error
        }
    }
    
    func cancelResetPassword() {
        if ProcessInfo.isRunningUnitTests { return }
        NotificationCenter.default.post(name: .UserLoggedOut, object: nil)
    }
}
