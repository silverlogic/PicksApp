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
    
    
    
    // MARK: - Generic Keys
    static let apiUrl = "ApiUrl"
    static let crashlytics = "Crashlytics"
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
