//
//  UIViewController+Extension.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/9/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import SVProgressHUD
import IQKeyboardManager
import Dodo
import KYNavigationProgress
import ImagePicker

// MARK: - Public Instance Methods For SVProgressHUD
extension UIViewController {
    
    /**
        Shows the progress hud.
    */
    func showProgresHud() {
        SVProgressHUD.show()
    }
    
    /**
        Dismisses the progress hud.
    */
    func dismissProgressHud() {
        SVProgressHUD.dismiss()
    }
    
    /**
        Displays a message in the hud and then dismisses it after
        a certain duration.
        
        - Parameters:
            - message: A `String` representing the message to display
                       in the hud.
            - iconType: A `HudIconType` representing the type of icon
                        to display in the hud.
            - duration: A `Double` indicating how long the hud should
                        stay in the window for. If `nil` is passed,
                        two will be used.
    */
    func dismissProgressHudWithMessage(_ message: String, iconType: HudIconType, duration: Double?) {
        var dismissDuration = 2.0
        if let dismissTime = duration {
            dismissDuration = dismissTime
        }
        switch iconType {
        case .success:
            SVProgressHUD.showSuccess(withStatus: message)
            break
        case .error:
            SVProgressHUD.showError(withStatus: message)
            break
        case .info:
            SVProgressHUD.showInfo(withStatus: message)
            break
        }
        SVProgressHUD.dismiss(withDelay: dismissDuration)
    }
}


// MARK: - Public Instance Methods For IQKeyboardManager
extension UIViewController {
    
    /**
        Enables or disables keyboard management.
     
        - Note: When leaving or dismissing a view controller,
                this method should get called to disable
                keyboard managment.
        
        - Parameter shouldEnable: A `Bool` indicating if
                                  keyboard management should
                                  be turned on or off.
    */
    func enableKeyboardManagement(_ shouldEnable: Bool) {
        IQKeyboardManager.shared().isEnabled = shouldEnable
    }
}


// MARK: - Public Instance Methods For Dodo
extension UIViewController {
    
    /**
        Displays a `Dodo` alert in the main window
        of the application.
     
        - Parameters:
            - message: A `String` representing the message
                       to display to the user.
            - alertType: A `DodoAlertType` representing the
                         type of `Dodo` alert to use.
    */
    func showDodoAlert(message: String, alertType: DodoAlertType) {
        switch alertType {
        case .success:
            view.dodo.success(message)
            break
        case .info:
            view.dodo.info(message)
            break
        case .warning:
            view.dodo.warning(message)
            break
        case .error:
            view.dodo.error(message)
            break
        }
    }
}


// MARK: - Public Instance Methods For KYNavigationProgress
extension UIViewController {
    
    /**
        Sets the progress bar of the navigation controller
        with a given progress.
     
        - Parameter progress: A `Float` representing the current
                              progress of a task.
    */
    func setProgressForNavigationBar(progress: Float) {
        navigationController?.setProgress(progress, animated: true)
    }
    
    /**
        Animates the finishing of the progress bar
        in the navigation controller.
    */
    func finishProgressBar() {
        navigationController?.finishProgress()
    }
    
    /**
        Animates the canceling of the progress bar
        in the navigation controller.
    */
    func cancelProgressBar() {
        navigationController?.cancelProgress()
    }
}


// MARK: - Public Instance Methods For SCLAlertView
extension UIViewController {
    
    /**
        Shows an error alert that auto dismisses.
     
        - Parameters:
            - title: A `String` representing the title to show
                     in the alert.
            - subTitle: A `String` representing the subtitle to
                        show in the alert.
    */
    func showErrorAlert(title: String, subTitle: String) {
        let alert = BaseAlertViewController(shouldAutoDismiss: true, shouldShowCloseButton: false)
        alert.showErrorAlert(title: title, subtitle: subTitle)
    }
    
    /**
        Shows an info alert that auto dismisses.
     
        - Parameters:
            - title: A `String` representing the title to show
                     in the alert.
            - subTitle: A `String` representing the subtitle to
                        show in the alert.
    */
    func showInfoAlert(title: String, subTitle: String) {
        let alert = BaseAlertViewController(shouldAutoDismiss: true, shouldShowCloseButton: false)
        alert.showInfoAlert(title: title, subtitle: subTitle)
    }
    
    /**
        Shows an edit alert.
     
        - Note: When the user taps on the submit button,
                validation occurs to ensure each textfield
                has a value before `submitButtonTapped` is
                invoked. If a textfield is empty, a shake animation
                will occur on the textfield and the alert stays in
                the view allowing the user to fill all missing
                textfields and then trying again.
     
        - Warning: If `textFieldAttributes.count` is not greater
                   than zero, the alert will not show.
     
        - Precondition: `textFieldAttributes.count` should be
                        greater than zero.
     
        - Parameters:
            - title: A `String` representing the title to show in
                     the alert.
            - subtitle: A `String` representing the subtitle to show
                        in the alert.
            - textFieldAttributes: An `[AlertTextFieldAttributes]`
                                   representing the attributes of each textfield
                                   in the alert. The size of the array
                                   determines the number of textfields to show
                                   in the alert.
            - submitButtonTapped: A closure that gets invoked when the user taps
                                  the submit button. A `[String: String]` gets passed
                                  that contains the values entered from the textfields.
                                  The keys for each value are the
                                  `placeholder` property from `AlertTextFieldAttributes` 
                                  provided in `textFieldAttributes`.
    */
    func showEditAlert(title: String, subtitle: String, textFieldAttributes: [AlertTextFieldAttributes], submitButtonTapped: @escaping (_ enteredValues: [String: String]) -> Void) {
        let alert = BaseAlertViewController(shouldAutoDismiss: false, shouldShowCloseButton: false)
        if textFieldAttributes.count == 0 { return }
        var textFields = [UITextField]()
        textFieldAttributes.forEach({ textFields.append(alert.addTextField(textfieldAttributes: $0)) })
        alert.addActionButton(title: NSLocalizedString("Miscellaneous.Submit", comment: "button title")) {
            textFields.forEach({ $0.resignFirstResponder() })
            let emptyTextFields = textFields.filter({ ($0.text?.isEmpty)! })
            if emptyTextFields.count > 0 {
                emptyTextFields.forEach({ $0.shake() })
                return
            }
            var enteredValues = [String: String]()
            textFields.forEach({ enteredValues[$0.placeholder!] = $0.text })
            submitButtonTapped(enteredValues)
            alert.hideView()
        }
        alert.addActionButton(title: NSLocalizedString("Miscellaneous.Cancel", comment: "alert title")) {
            textFields.forEach({ $0.resignFirstResponder() })
            alert.hideView()
        }
        alert.showEditAlert(title: title, subtitle: subtitle)
    }
}


// MARK: - Public Instance Methods For ImagePicker
extension UIViewController {
    
    /// Internal helper for getting the selected images from the delegate.
    fileprivate static var userSelectedImages: ((_ images: [UIImage]) -> Void)!
    
    /**
        Shows the image picker to the user.
     
        - Parameters:
            - numberOfImages: An `Int` representing the amount of images
                              the user is allowed to select.
            - imagesSelected: A closure that gets invoked when images have
                              been selected. Passes an `[UIImage]` containing
                              the selected images.
    */
    func showImagePicker(numberOfImages: Int, imagesSelected: @escaping (_ images: [UIImage]) -> Void) {
        var imagePickerConfiguration = Configuration()
        imagePickerConfiguration.backgroundColor = .white
        imagePickerConfiguration.gallerySeparatorColor = UIColor.colorFromHexValue(StyleConstants.colorValueBaseAppBlue)
        imagePickerConfiguration.mainColor = .white
        imagePickerConfiguration.settingsColor = UIColor.colorFromHexValue(StyleConstants.colorValueBaseAppBlue)
        imagePickerConfiguration.bottomContainerColor = UIColor.colorFromHexValue(StyleConstants.colorValueBaseAppBlue)
        imagePickerConfiguration.doneButtonTitle = NSLocalizedString("Miscellaneous.Finish", comment: "button title")
        imagePickerConfiguration.noImagesTitle = NSLocalizedString("ImagePicker.NoImages", comment: "no images title")
        imagePickerConfiguration.requestPermissionTitle = NSLocalizedString("ImagePicker.RequestPermission.Title", comment: "Request title")
        imagePickerConfiguration.requestPermissionMessage = NSLocalizedString("ImagePicker.RequestPermission.Message", comment: "Request message")
        imagePickerConfiguration.recordLocation = false
        imagePickerConfiguration.allowMultiplePhotoSelection = false
        let imagePicker = ImagePickerController(configuration: imagePickerConfiguration)
        imagePicker.delegate = self
        imagePicker.imageLimit = numberOfImages
        present(imagePicker, animated: true, completion: nil)
        UIViewController.userSelectedImages = { (images: [UIImage]) in
            imagesSelected(images)
        }
    }
}


// MARK: - ImagePickerDelegate
extension UIViewController: ImagePickerDelegate {
    public func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    public func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        // No implementation
    }
    
    public func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        UIViewController.userSelectedImages(images)
        imagePicker.dismiss(animated: true, completion: nil)
    }
}


// MARK: - Public Instance Methods For UIActivityIndicatorView
extension UIViewController {
    
    /**
        Shows a native activity indicator in the center
        of the view. This would be used when loading 
        content for an `UITableView` or `UICollectionView`.
    */
    func showActivityIndicator() {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicatorView.color = UIColor.colorFromHexValue(StyleConstants.colorValueBaseAppBlue)
        activityIndicatorView.tag = 99
        activityIndicatorView.center = view.center
        activityIndicatorView.alpha = 0
        activityIndicatorView.startAnimating()
        view.addSubview(activityIndicatorView)
        activityIndicatorView.animateShow()
    }
    
    /**
        Dismisses the native activity indicator from
        the center of the view.
    */
    func dismissActivityIndicator() {
        guard let activityIndicatorView = view.subviews.filter({ $0.tag == 99 }).first else { return }
        activityIndicatorView.animateHide()
        activityIndicatorView.removeFromSuperview()
    }
}


// MARK: - Public Class Methods
extension UIViewController {
    
    /// The storyboard identifier used.
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}


/**
    An enum that specifies the
    type of icon to display in 
    the progress hud.
*/
enum HudIconType {
    case success
    case error
    case info
}


/**
    An enum that specifies the
    type of `Dodo` alert to display
    in the window.
*/
enum DodoAlertType {
    case success
    case info
    case warning
    case error
}
