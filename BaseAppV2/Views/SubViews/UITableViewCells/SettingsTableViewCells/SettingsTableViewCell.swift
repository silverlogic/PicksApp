//
//  SettingsTableViewCell.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/17/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A `BaseTableViewCell` responsible for handling
    and configuring the view of a setting cell.
*/
final class SettingsTableViewCell: BaseTableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var settingsImageView: UIImageView!
    @IBOutlet fileprivate weak var settingsTypeLabel: UILabel!
    @IBOutlet fileprivate weak var settingsOptionalInfoLabel: UILabel!
    
    
    // MARK: - Private Class Attributes
    fileprivate static let cellHeight: CGFloat = 50.0
}


// MARK: - Public Instance Methods
extension SettingsTableViewCell {
    
    /**
        Configures the view of a settings cell.
     
        - Parameters:
            - settingImage: A `UIImage` representing the
                             image to use for a setting.
            - settingName: A `String` representing the name
                           of a setting.
            - optionalInfo: A `String` representing optional
                            info to display on the right side
                            of the cell. It could be the invite
                            code of the current user or the
                            version of the app. `nil` can be passed
                            as a parameter.
    */
    func configure(settingImage: UIImage, settingName: String, optionalInfo: String?) {
        settingsImageView.image = settingImage
        settingsTypeLabel.text = settingName
        guard let text = optionalInfo else { return }
        settingsOptionalInfoLabel.text = text
    }
}


// MARK: - Public Class Methods
extension SettingsTableViewCell {
    override class func height() -> CGFloat {
        return cellHeight
    }
}
