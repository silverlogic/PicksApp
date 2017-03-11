//
//  SettingsViewController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/10/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A `UIViewController` responsible for
    managing the settings of the application
*/
final class SettingsViewController: UIViewController {
    
    // @TODO: Use MVVM for logging out
    @IBAction private func logoutButtonTapped() {
        SessionManager.shared.logout()
    }
}
