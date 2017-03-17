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
    var applicationVersion: String { get }
    var inviteCode: String { get }
    
    
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
    var applicationVersion: String
    var inviteCode: String
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `SettingViewModel`.
    init() {
        applicationVersion = ConfigurationManager.shared.versionNumber
        guard let referralCode = SessionManager.shared.currentUser?.referralCode else {
            inviteCode = ""
            return
        }
        inviteCode = referralCode
    }
    
    
    // MARK: - SettingViewModelProtocol Methods
    func logout() {
        SessionManager.shared.logout()
    }
}
