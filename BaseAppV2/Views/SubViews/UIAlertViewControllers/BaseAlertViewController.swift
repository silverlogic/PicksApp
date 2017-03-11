//
//  BaseAlertViewController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/14/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import SCLAlertView

/**
    A base class for having subclasses
    of `SCLAlertView`. It also defines
    and sets default attributes for an
    instance.
*/
class BaseAlertViewController: SCLAlertView {
    
    // MARK: - Attributes
    fileprivate let titleFont = UIFont.systemFont(ofSize: StyleConstants.defaultBaseAppFontSizeMedium)
    fileprivate let defaultFont = UIFont.systemFont(ofSize: StyleConstants.defaultBaseAppFontSizeSmall)
    fileprivate let cornerRadius: CGFloat = 3.0
    fileprivate let borderColor = UIColor.lightGray.cgColor
    fileprivate let borderWidth: CGFloat = 1.0
    fileprivate let placeHolderAndTintTextColor = UIColor.darkGray
    fileprivate let noDurationInterval: TimeInterval = 0.0
    fileprivate var defaultDurationInterval: TimeInterval = 2.0
    fileprivate var shouldAutoDismiss = false
    
    
    // MARK: Getters & Setters
    var durationInterval: TimeInterval {
        get {
            return defaultDurationInterval
        }
        set {
            defaultDurationInterval = newValue
        }
    }
    
    
    // MARK: - Initializers
    init(_ shouldAutoDismiss: Bool, shouldShowCloseButton: Bool) {
        let appearance = SCLAppearance(
            kTitleFont: titleFont,
            kTextFont: defaultFont,
            kButtonFont: defaultFont,
            showCloseButton: shouldShowCloseButton,
            shouldAutoDismiss: shouldAutoDismiss,
            titleColor: UIColor.black
        )
        self.shouldAutoDismiss = shouldAutoDismiss
        super.init(appearance: appearance)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init() {
        super.init()
    }
}


// MARK: - Public Instance Methods
extension BaseAlertViewController {
    func addTextField(_ title: String?, isSecure: Bool) -> UITextField {
        let textField = super.addTextField(title)
        textField.isSecureTextEntry = isSecure
        textField.layer.cornerRadius = cornerRadius
        textField.layer.borderColor = borderColor
        textField.layer.borderWidth = borderWidth
        textField.textColor = UIColor.black
        textField.tintColor = UIColor.black
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        guard let placeholderText = textField.placeholder else { return textField }
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSForegroundColorAttributeName : placeHolderAndTintTextColor])
        return textField
    }
    
    func addActionButton(_ title: String, buttonTapped: @escaping () -> Void) {
        _ = addButton(title, backgroundColor: UIColor.colorFromHexValue(StyleConstants.colorValueBaseAppBlue), textColor: .white, showDurationStatus: false, action: buttonTapped)
    }
    
    func showEditAlert(_ title: String, subtitle: String) {
        _ = showEdit(title, subTitle: subtitle, closeButtonTitle: nil, duration: noDurationInterval, colorStyle: StyleConstants.colorValueBaseAppBlue, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: .topToBottom)
    }
    
    func showErrorAlert(_ title: String, subtitle: String) {
        let duration = shouldAutoDismiss ? defaultDurationInterval : noDurationInterval
        _ = showError(title, subTitle: subtitle, closeButtonTitle: NSLocalizedString("Alert.Close", comment: "close"), duration: duration, colorStyle: StyleConstants.colorValueBaseAppBlue, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: .topToBottom)
    }
    
    func showInfoAlert(_ title: String, subtitle: String) {
        let duration = shouldAutoDismiss ? defaultDurationInterval : noDurationInterval
        _ = showInfo(title, subTitle: subtitle, closeButtonTitle: NSLocalizedString("Alert.Close", comment: "close"), duration: duration, colorStyle: StyleConstants.colorValueBaseAppBlue, colorTextButton: 0xFFFFFF, circleIconImage: nil, animationStyle: .topToBottom)
    }
}
