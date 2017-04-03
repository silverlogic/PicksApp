//
//  Constants.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 2/28/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    An enum that defines constants used for
    configuration of the application.
*/
enum ConfigurationConstants {
    
    // MARK: - File Constants
    static let globalConfiguration = "globalconfiguration"
    
    
    // MARK: - File Type Constants
    static let propertyListType = "plist"
    
    
    // MARK: - Environment Keys
    static let local = "Local"
    static let staging = "Staging"
    static let stable = "Stable"
    static let production = "Production"
    
    
    // MARK: - OAuth Keys
    static let appId = "AppId"
    static let redirectUri = "RedirectUri"
    
    
    // MARK: - Generic Keys
    static let apiUrl = "ApiUrl"
    static let crashlytics = "Crashlytics"
    static let facebook = "Facebook"
    static let linkedIn = "LinkedIn"
    static let twitter = "Twitter"
}


/**
    An enum that defines constants used for
    setting up the Core Data stack of the
    application.
*/
enum CoreDataStackConstants {
    
    // MARK: - File Constants
    static let model = "Model"
    static let sqLite = "Model.sqlite"
    
    
    // MARK: - File Type Constants
    static let modelType = "momd"
}


/**
    An enum that defines constants used
    for managing the session of the current
    user.
*/
enum SessionConstants {
    
    // MARK: - User Constants
    static let userId = "userId"
    
    
    // MARK: - Authorization Token Constants
    static let authorizationToken = "authorizationToken"
}


/**
    An enum that defines constants used
    for knowing the registration status
    of push notifications.
*/
enum PushNotificationConstants {
    
    // MARK: - Registration Constants
    static let isRegistered = "isRegistered"
}


/**
    An enum that defines constants used for
    styling the application.
*/
enum StyleConstants {
    
    // MARK: - Color Constants
    static let colorValueBaseAppBlue: UInt = 0x3D8DD4
    
    
    // MARK: - Font Size Constants
    static let defaultBaseAppFontSizeSmall: CGFloat = 10.0
    static let defaultBaseAppFontSizeMedium: CGFloat = 17.0
    static let defaultBaseAppFontSizeLarge: CGFloat = 25.0
    
    
    // MARK: - Keyboard Constants
    static let keyboardStyle: UIKeyboardAppearance = .default
}

/**
    An enum that defines constants used
    for identifying OAuth errors that
    can occur.
*/
enum OAuthErrorConstants {
    static let invalidProvider = "Invalid provider 😞"
    static let invalidCredentials = "invalid_credentials 😞"
    static let noEmailProvided = "no_email_provided 😞"
    static let emailAlreadyInUse = "email_already_in_use 😞"
}


/**
    An enum that defines the indexes
    of the tabbar.
*/
enum TabbarIndex: Int {
    case profile
    case users
    case settings
}
