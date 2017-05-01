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
protocol SettingViewModelProtocol: class {
    
    // MARK: - Instance Attributes
    var applicationVersion: DynamicBinderInterface<String> { get }
    var inviteCode: DynamicBinderInterface<String> { get }
    var changeEmailRequestError: DynamicBinderInterface<BaseError?> { get }
    var changeEmailRequestSuccess: DynamicBinderInterface<Bool> { get }
    
    
    // MARK: - Instance Methods
    func logout()
    func changeEmailRequest(newEmail: String)
}


/**
    A `ViewModelsManager` class extension for `SettingViewModelProtocol`.
 */
extension ViewModelsManager {
    
    /**
        Returns an instance conforming to `SettingViewModelProtocol`.
     
        - Return: an instance conforming to `SettingViewModelProtocol`.
     */
    class func settingViewModel() -> SettingViewModelProtocol {
        return SettingViewModel()
    }
}


/**
    A class that conforms to `SettingViewModelProtocol`
    and implements it.
*/
fileprivate final class SettingViewModel: SettingViewModelProtocol {
    
    // MARK: - SettingViewModelProtocol Attributes
    var applicationVersion: DynamicBinderInterface<String> {
        return applicationVersionBinder.interface
    }
    var inviteCode: DynamicBinderInterface<String> {
        return inviteCodeBinder.interface
    }
    var changeEmailRequestError: DynamicBinderInterface<BaseError?> {
        return changeEmailRequestErrorBinder.interface
    }
    var changeEmailRequestSuccess: DynamicBinderInterface<Bool> {
        return changeEmailRequestSuccessBinder.interface
    }
    
    
    // MARK: - Private Instance Attributes
    fileprivate var applicationVersionBinder: DynamicBinder<String>
    fileprivate var inviteCodeBinder: DynamicBinder<String>
    fileprivate var changeEmailRequestErrorBinder: DynamicBinder<BaseError?>
    fileprivate var changeEmailRequestSuccessBinder: DynamicBinder<Bool>
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `SettingViewModel`.
    init() {
        applicationVersionBinder = DynamicBinder(ConfigurationManager.shared.versionNumber)
        if let referralCode = SessionManager.shared.currentUser.value?.referralCode {
            inviteCodeBinder = DynamicBinder(referralCode)
        } else {
            inviteCodeBinder = DynamicBinder("")
        }
        changeEmailRequestErrorBinder = DynamicBinder(nil)
        changeEmailRequestSuccessBinder = DynamicBinder(false)
        SessionManager.shared.currentUser.interface.bindAndFire({ [weak self] (user: User?) in
            guard let strongSelf = self,
                  let currentUser = user,
                  let referralCode = currentUser.referralCode else { return }
            strongSelf.inviteCodeBinder.value = referralCode
        }, for: self)
    }
    
    
    // MARK: - Deinitializers
    
    /// Deinitializes an instance of `SettingViewModel`.
    deinit {
        SessionManager.shared.currentUser.interface.unbind(for: self)
    }
    
    
    // MARK: - SettingViewModelProtocol Methods
    func logout() {
        if ProcessInfo.isRunningUnitTests { return }
        SessionManager.shared.logout()
    }
    
    func changeEmailRequest(newEmail: String) {
        if newEmail.isEmpty {
            changeEmailRequestErrorBinder.value = BaseError.fieldsEmpty
            return
        }
        AuthenticationManager.shared.changeEmailRequest(newEmail: newEmail, success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.changeEmailRequestSuccessBinder.value = true
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            strongSelf.changeEmailRequestErrorBinder.value = error
        }
    }
}
