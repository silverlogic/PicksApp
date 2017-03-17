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
    
    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var tableView: UITableView!
    
    
    // MARK: - Private Instance Attributes
    fileprivate var settingViewModel = SettingViewModel()
    fileprivate enum Settings: Int, CaseCount {
        case inviteCode
        case versionNumber
        case termsOfUse
        case privacyPolicy
        case sendFeedback
        case changePassword
        case logout
        static let caseCount = Settings.numberOfCases()
    }
}


// MARK: - Lifecycle
extension SettingsViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}


// MARK: - UITableViewDataSource
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Settings.caseCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Settings(rawValue: indexPath.section) else { return UITableViewCell() }
        let settingCell: SettingsTableViewCell = tableView.dequeueCell()
        switch section {
        case .inviteCode:
            settingCell.configure(settingImage: #imageLiteral(resourceName: "icon-invitecode"), settingName: NSLocalizedString("SettingsViewController.InviteCode", comment: "Setting Label"), optionalInfo: settingViewModel.inviteCode)
            break
        case .versionNumber:
            settingCell.configure(settingImage: #imageLiteral(resourceName: "icon-version"), settingName: NSLocalizedString("SettingsViewController.Version", comment: "Setting Label"), optionalInfo: settingViewModel.applicationVersion)
            break
        case .termsOfUse:
            settingCell.configure(settingImage: #imageLiteral(resourceName: "icon-termsofuse"), settingName: NSLocalizedString("SettingsViewController.TermsOfUse", comment: "Setting Label"), optionalInfo: nil)
            break
        case .privacyPolicy:
            settingCell.configure(settingImage: #imageLiteral(resourceName: "icon-privacypolicy"), settingName: NSLocalizedString("SettingsViewController.PrivacyPolicy", comment: "Setting Label"), optionalInfo: nil)
            break
        case .sendFeedback:
            settingCell.configure(settingImage: #imageLiteral(resourceName: "icon-sendfeedback"), settingName: NSLocalizedString("SettingsViewController.SendFeedback", comment: "Setting Label"), optionalInfo: nil)
            break
        case .changePassword:
            settingCell.configure(settingImage: #imageLiteral(resourceName: "icon-changepassword"), settingName: NSLocalizedString("SettingsViewController.ChangePassword", comment: "Setting Label"), optionalInfo: nil)
            break
        case .logout:
            settingCell.configure(settingImage: #imageLiteral(resourceName: "icon-logout"), settingName: NSLocalizedString("SettingsViewController.Logout", comment: "Setting Label"), optionalInfo: nil)
            break
        }
        return settingCell
    }
}


// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        guard let section = Settings(rawValue: indexPath.section), section == .versionNumber || section == .inviteCode else {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        guard let section = Settings(rawValue: indexPath.section), section == .versionNumber || section == .inviteCode else {
            return indexPath
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let section = Settings(rawValue: indexPath.section) else { return }
        switch section {
        case .inviteCode, .versionNumber: break
        case .termsOfUse:
            // @TODO: Call method on view model for terms of use
            break
        case .privacyPolicy:
            // @TODO: Call method on view model for privacy policy
            break
        case .sendFeedback:
            // @TODO: Call method on view model for sending feedback
            break
        case .changePassword:
            // @TODO: Call method on view model for chaning password
            break
        case .logout:
            settingViewModel.logout()
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SettingsTableViewCell.height()
    }
}


// MARK: - Private Instance Methods
fileprivate extension SettingsViewController {
    
    /// Sets up the default logic for the view.
    fileprivate func setup() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.reloadData()
    }
}
