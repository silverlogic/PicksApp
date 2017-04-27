//
//  FacebookManager.swift
//  BaseAppV2
//
//  Created by Michael Sevy on 4/27/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import FBSDKShareKit

/**
    A singleton responsible for facebook operations.
*/
final class FacebookManager {

    // MARK: - Shared Instance
    static let shared = FacebookManager()


    // MARK: - Initializers

    /**
        Initializes a shared instance of `FacebookManager`.
    */
    private init() {}
}


// MARK: - Private Instance Methods
fileprivate extension FacebookManager {

    /**
        Fetches the relavant data for the Facebook user logged in.

        - Parameters:
            - token: A `String` representing the token received from
                     a successful facebook login.
            - success: A closure that gets invoked when sending the
                       request was successful.
            - failure: A closure that gets invoked when sending the
                       request failed. Passes a `BaseError` object that
                       contains the error that occured.
    */
    fileprivate func fetchFacebookData(facebookToken: String,_ success: @escaping (FacebookUserInfo) -> Void, failure: @escaping (_ error: BaseError) -> Void) {
        let params = ["fields": "email, cover, first_name, last_name"]
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: params)
        graphRequest!.start(completionHandler: { (connection, result, error) -> Void in
            if ((error) != nil) {
                failure(error as! BaseError)
            } else {
                typealias JSONDictionary = [String: Any]
                let results = result as? [String:Any]
                if let email = results?["email"] as? String,
                   let firstName = results?["first_name"] as? String,
                   let lastName = results?["last_name"] as? String,
                   let cover = results?["cover"] as? [String:Any]?,
                   let avatarUrl = cover?["source"] as? String? {
                    success(FacebookUserInfo(email: email, facebookAccessToken: facebookToken, firstName: firstName, lastName: lastName, avatar: avatarUrl))
                }
            }
        })
    }
}


// MARK: - Public Instance Methods
extension FacebookManager {

    /**
        Activates the Facebook App Events SDK.
     */
    func activate() {
        FBSDKAppEvents.activateApp()
    }

    /** 
        Logs the user out and clears token.
    */
    func logout() {
        FBSDKLoginManager().logOut()
    }
    
    /**
        Initializes the facebook application delegate.
     */
    func initializeDelegate(application: UIApplication, launchOptions: [UIApplicationLaunchOptionsKey : Any]?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    /**
        Initializes the facebook url delegate.
    */
    func initializeURLDelegate(application: UIApplication, url: URL, options:[UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url as URL!, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
    }

    /**
        Initialize Source Application delegate.
     */
    func initializeSourceApplicationDelegate(application: UIApplication, url: URL, sourceApplication: String?, annotation: Any?) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    /**
        Logs a user into Facebook to retrieve their data which eventually
        will be sent to the Picks API

        - Parameters:
            - viewController: The View Controller from which the facebook button is initiated.
            -   success: A closure that gets invoked when sending the
                         request was successful.
            - failure: A closure that gets invoked when sending the
                       request failed. Passes a `BaseError` object that
                       contains the error that occured.
    */
    func loginToFacebookForPermissions(viewController: UIViewController, _ success: @escaping (_ facebookData: FacebookUserInfo) -> Void, failure: @escaping (_ error: BaseError) -> Void) {
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile", "email"], from:viewController) { [weak self] (result, error) -> Void in
            if (result?.grantedPermissions != nil) {
                if (result!.grantedPermissions.contains("email")) {
                    guard let strongSelf = self else { return }
                    strongSelf.fetchFacebookData(facebookToken: FBSDKAccessToken.current().tokenString, { (loginData: FacebookUserInfo) in
                        success(loginData)
                    }, failure: { (error: BaseError) in
                        failure(error)
                    })
                }
            }
        }
    }
}
