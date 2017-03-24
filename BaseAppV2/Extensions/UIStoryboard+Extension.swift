//
//  UIStoryboard+Extension.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/9/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

// MARK: - Public Class Methods
extension UIStoryboard {
    
    // MARK: - UIViewController Loaders
    static func loadInitializeViewController() -> UITabBarController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateInitialViewController() as! BaseTabBarController
    }
    
    static func loadLoginViewController() -> LoginViewController {
        return loadControllerFromMain(type: LoginViewController.self)
    }
}


// MARK: - Private Class Methods
fileprivate extension UIStoryboard {
    
    /**
        Loads a view controller from the main
        storyboard.
     
        - Parameter type: A `UIViewController.Type` indicating what type to load.
        
        - Returns: A `T` representing the view controller
                   to load.
    */
    fileprivate static func loadControllerFromMain<T: UIViewController>(type: T.Type) -> T {
        return loadControllerFrom(.main, type: type)
    }
    
    /**
        Loads a view controller from a storyboard.
     
        - Parameters:
            - storyboard: A `Storyboard` represeting the storyboard
                          to load the view controller from.
            - type: A `UIViewController.Type` representing the type to load.

        - Returns: A `T` representing the view controller to load.
    */
    private static func loadControllerFrom<T: UIViewController>(_ storyboard: Storyboard, type: T.Type) -> T {
        let uiStoryboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return uiStoryboard.instantiateViewController(withIdentifier: T.storyboardIdentifier) as! T
    }
}


/**
    An enum that specifies which
    storyboard to load.
*/
fileprivate enum Storyboard: String {
    case main = "Main"
}
