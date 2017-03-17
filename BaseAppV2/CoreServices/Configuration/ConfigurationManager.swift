//
//  ConfigurationManager.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 2/28/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A singleton responsible for managing global configurations 
    of the application.
*/
final class ConfigurationManager {
    
    // MARK: - Shared Instance
    static let shared = ConfigurationManager()
    
    
    // MARK: - Public Instance Attributes
    var environmentMode = EnvironmentMode.staging
    lazy var versionNumber: String = {
        guard let infoDictionary = Bundle.main.infoDictionary,
              let shortVersionNumber = infoDictionary["CFBundleShortVersionString"] as? String else { return "" }
        return "v\(shortVersionNumber)"
    }()
    
    
    // MARK: - Private Instance Attributes
    fileprivate lazy var _globalConfigurationDictionary: [String: Any] = {
        guard let localizedFilePath = Bundle.main.path(forResource: ConfigurationConstants.globalConfiguration, ofType: ConfigurationConstants.propertyListType),
            let propertyListDictionary = NSDictionary(contentsOfFile: localizedFilePath) as? [String: Any] else {
                return [String: Any]()
        }
        return propertyListDictionary
    }()
    
    
    // MARK: - Initializers
    
    /// Initializes a shared instance of `ConfigurationManager`.
    private init() {}
}


// MARK: - Getters & Setters
extension ConfigurationManager {
    
    /// The current API key used for Fabric and Crashlytics.
    var crashlyticsApiKey: String? {
        guard let apiKey = configurationValueForKey(ConfigurationConstants.crashlytics) as? String else {
            return nil
        }
        assert(apiKey.characters.count > 0, "Fabric/Crashlytics Key Not Provided In Global Configuration File!")
        return apiKey
    }
    
    /// The current base api url to use for perfoming network requests.
    var apiUrl: String? {
        guard let apiUrlDictionary = configurationValueForKey(ConfigurationConstants.apiUrl) as? [String: Any],
              let apiUrl = configurationValueFromEnvironmentDictionary(apiUrlDictionary) as? String else {
                return nil
        }
        assert(apiUrl.characters.count > 0, "API Url Not Provided In Global Configuration File!")
        return apiUrl
    }
}


// MARK: - Private Instance Methods
fileprivate extension ConfigurationManager {
    
    /**
        Gets the value from the global configuration dictionary based on a given key.
     
        - Parameter key: A `String` representing a key to a value in the dictionary.
     
        - Returns: An `Any?` representing the value of the given key. If a value can't be
                   retrieved, `nil` will be returned.
    */
    fileprivate func configurationValueForKey(_ key: String) -> Any? {
        return _globalConfigurationDictionary[key]
    }
    
    /**
        Gets the value from a given dictionary that has environment modes as keys.
     
        - Precondition: For an environment dictionary, there should be exactly four
                        key/value pairs. If this condition isn't met, `nil` will be
                        returned.
     
        - Parameter environmentDictionary: A `[String: Any]` representing the dictionary
                                           to retrieve the value from.
     
        - Returns: An `Any?` representing the value based on the current environment
                   mode. If a value can't be retrieved, `nil` will be returned.
    */
    fileprivate func configurationValueFromEnvironmentDictionary(_ environmentDictionary: [String: Any]) -> Any? {
        if environmentDictionary.count != 4 {
            return nil
        }
        switch environmentMode {
        case .local:
            return environmentDictionary[ConfigurationConstants.local]
        case .staging:
            return environmentDictionary[ConfigurationConstants.staging]
        case .stable:
            return environmentDictionary[ConfigurationConstants.stable]
        case .production:
            return environmentDictionary[ConfigurationConstants.production]
        }
    }
}


// MARK: - Environment Mode
enum EnvironmentMode {
    case local
    case staging
    case stable
    case production
}
