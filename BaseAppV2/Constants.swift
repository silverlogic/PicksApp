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
