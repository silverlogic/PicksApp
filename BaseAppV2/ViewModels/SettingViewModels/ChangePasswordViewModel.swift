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
    var changePasswordError: DynamicBinderInterface<BaseError?> { get }
    var changePasswordSuccess: DynamicBinderInterface<Bool> { get }
    
    
    // MARK: - Instance Methods
    func changePassword()
}


/**
    A `ViewModelsManager` class extension for `ChangePasswordViewModelProtocol`.
 */
extension ViewModelsManager {
    
    /**
        Returns an instance conforming to `ChangePasswordViewModelProtocol`.
     
        - Return: an instance conforming to `ChangePasswordViewModelProtocol`.
     */
    class func changePasswordViewModel() -> ChangePasswordViewModelProtocol {
        return ChangePasswordViewModel()
    }
}


/**
    A class that conforms to `ChangePasswordViewModelProtocol`
    and implements it.
*/
fileprivate final class ChangePasswordViewModel: ChangePasswordViewModelProtocol {
    
    // MARK: - ChangePasswordViewModelProtocol Attributes
    var currentPassword: String
    var newPassword: String
    var changePasswordError: DynamicBinderInterface<BaseError?> {
        return changePasswordErrorBinder.interface
    }
    var changePasswordSuccess: DynamicBinderInterface<Bool> {
        return changePasswordSuccessBinder.interface
    }
    
    
    // MARK: - Private Instance Attributes
    fileprivate var changePasswordErrorBinder: DynamicBinder<BaseError?>
    fileprivate var changePasswordSuccessBinder: DynamicBinder<Bool>
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `ChangePasswordViewModel`.
    init() {
        currentPassword = ""
        newPassword = ""
        changePasswordErrorBinder = DynamicBinder(nil)
        changePasswordSuccessBinder = DynamicBinder(false)
    }
    
    
    // MARK: - ChangePasswordViewModelProtocol Methods
    func changePassword() {
        if currentPassword.isEmpty || newPassword.isEmpty {
            changePasswordErrorBinder.value = BaseError.fieldsEmpty
            return
        }
        AuthenticationManager.shared.changePassword(currentPassword: currentPassword, newPassword: newPassword, success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.changePasswordSuccessBinder.value = true
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            strongSelf.changePasswordErrorBinder.value = error
        }
    }
}
