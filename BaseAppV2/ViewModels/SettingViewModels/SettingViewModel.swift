//
//  SettingViewModel.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/17/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A protocol for defining state and behavior
    for settings.
*/
protocol SettingViewModelProtocol {
    
    // MARK: - Instance Attributes
    var applicationVersion: DynamicBinder<String> { get }
    var inviteCode: DynamicBinder<String> { get }
    var changeEmailRequestError: DynamicBinder<BaseError?> { get }
    var changeEmailRequestSuccess: DynamicBinder<Bool> { get }
    
    
    // MARK: - Instance Methods
    func logout()
    func changeEmailRequest(newEmail: String)
}


/**
    A class that conforms to `SettingViewModelProtocol`
    and implements it.
*/
final class SettingViewModel: SettingViewModelProtocol {
    
    // MARK: - SettingViewModelProtocol Attributes
    var applicationVersion: DynamicBinder<String>
    var inviteCode: DynamicBinder<String>
    var changeEmailRequestError: DynamicBinder<BaseError?>
    var changeEmailRequestSuccess: DynamicBinder<Bool>
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `SettingViewModel`.
    init() {
        applicationVersion = DynamicBinder(ConfigurationManager.shared.versionNumber)
        if let referralCode = SessionManager.shared.currentUser.value?.referralCode {
            inviteCode = DynamicBinder(referralCode)
        } else {
            inviteCode = DynamicBinder("")
        }
        changeEmailRequestError = DynamicBinder(nil)
        changeEmailRequestSuccess = DynamicBinder(false)
        SessionManager.shared.currentUser.bindAndFire({ [weak self] (user: User?) in
            guard let strongSelf = self,
                  let currentUser = user,
                  let referralCode = currentUser.referralCode else { return }
            strongSelf.inviteCode.value = referralCode
        }, for: self)
    }
    
    
    // MARK: - Deinitializers
    
    /// Deinitializes an instance of `SettingViewModel`.
    deinit {
        SessionManager.shared.currentUser.removeListeners(for: self)
    }
    
    
    // MARK: - SettingViewModelProtocol Methods
    func logout() {
        if ProcessInfo.isRunningUnitTests { return }
        SessionManager.shared.logout()
    }
    
    func changeEmailRequest(newEmail: String) {
        if newEmail.isEmpty {
            changeEmailRequestError.value = BaseError.fieldsEmpty
            return
        }
        AuthenticationManager.shared.changeEmailRequest(newEmail: newEmail, success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.changeEmailRequestSuccess.value = true
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            strongSelf.changeEmailRequestError.value = error
        }
    }
}
