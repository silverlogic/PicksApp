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
