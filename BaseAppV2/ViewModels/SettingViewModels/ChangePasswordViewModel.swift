//
//  ChangePasswordViewModel.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 4/10/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A protocol for defining state and behavior
    for changing a password.
*/
protocol ChangePasswordViewModelProtocol: class {
    
    // MARK: - Instance Attributes
    var currentPassword: String { get set }
    var newPassword: String { get set }
    var changePasswordError: DynamicBinder<BaseError?> { get }
    var changePasswordSuccess: DynamicBinder<Bool> { get }
    
    
    // MARK: - Instance Methods
    func changePassword()
}


/**
    A class that conforms to `ChangePasswordViewModelProtocol`
    and implements it.
*/
final class ChangePasswordViewModel: ChangePasswordViewModelProtocol {
    
    // MARK: - ChangePasswordViewModelProtocol Attributes
    var currentPassword: String
    var newPassword: String
    var changePasswordError: DynamicBinder<BaseError?>
    var changePasswordSuccess: DynamicBinder<Bool>
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `ChangePasswordViewModel`.
    init() {
        currentPassword = ""
        newPassword = ""
        changePasswordError = DynamicBinder(nil)
        changePasswordSuccess = DynamicBinder(false)
    }
    
    
    // MARK: - ChangePasswordViewModelProtocol Methods
    func changePassword() {
        if currentPassword.isEmpty || newPassword.isEmpty {
            changePasswordError.value = BaseError.fieldsEmpty
            return
        }
        AuthenticationManager.shared.changePassword(currentPassword: currentPassword, newPassword: newPassword, success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.changePasswordSuccess.value = true
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            strongSelf.changePasswordError.value = error
        }
    }
}
