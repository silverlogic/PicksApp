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
    
    
    // MARK: - Instance Methods
    func logout()
    // @TODO: Add behavior for differnt setting when implemented.
}


/**
    A class that conforms to `SettingViewModelProtocol`
    and implements it.
*/
final class SettingViewModel: SettingViewModelProtocol {
    
    // MARK: - SettingViewModelProtocol Attributes
    var applicationVersion: DynamicBinder<String>
    var inviteCode: DynamicBinder<String>
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `SettingViewModel`.
    init() {
        applicationVersion = DynamicBinder(ConfigurationManager.shared.versionNumber)
        if let referralCode = SessionManager.shared.currentUser.value?.referralCode {
            inviteCode = DynamicBinder(referralCode)
        } else {
            inviteCode = DynamicBinder("")
        }
        SessionManager.shared.currentUser.bindAndFire { [weak self] (user: User?) in
            guard let strongSelf = self,
                  let currentUser = user,
                  let referralCode = currentUser.referralCode else { return }
            strongSelf.inviteCode.value = referralCode
        }
    }
    
    
    // MARK: - SettingViewModelProtocol Methods
    func logout() {
        SessionManager.shared.logout()
    }
}
