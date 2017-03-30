//
//  AppDelegate.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 2/28/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import UIKit
import SVProgressHUD
import AlamofireNetworkActivityIndicator
import IQKeyboardManager
import Dodo
import Fabric
import Crashlytics

final class AppDelegate: UIResponder {
    
    // MARK: - Public Instance Methods
    var window: UIWindow?
}


// MARK: - UIApplicationDelegate
extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        _ = ConfigurationManager.shared
        _ = CoreDataStack.shared
        _ = AppLogger.shared
        _ = SessionManager.shared
        _ = DeepLinkManager.shared
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        NotificationCenter.default.addObserver(self, selector: #selector(loadAuthenticationFlow), name: .UserLoggedOut, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadApplicationFlow), name: .UserLoggedIn, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadForgotPasswordResetFlow(notification:)), name: .PasswordReset, object: nil)
        window = UIWindow(frame: UIScreen.main.bounds)
        setInitialFlow()
        configureBusinessLogic(launchOptions: launchOptions)
        configureUIComponents()
        window?.makeKeyAndVisible()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        DeepLinkManager.shared.respondToUrlScheme(url)
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        DeepLinkManager.shared.respondToUniversalLink(userActivity: userActivity)
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        NotificationCenter.default.removeObserver(self)
    }
}


// MARK: - Private Instance Methods
fileprivate extension AppDelegate {
    
    /**
        Determines which flow the user should begin
        with based on their current session.
    */
    fileprivate func setInitialFlow() {
        guard let _ = SessionManager.shared.authorizationToken else {
            loadAuthenticationFlow()
            return
        }
        loadApplicationFlow()
    }
    
    /// Configures default UI components used universally.
    fileprivate func configureUIComponents() {
        var fontSize = StyleConstants.defaultBaseAppFontSizeMedium
        if UIDevice.current.userInterfaceIdiom == .pad {
            fontSize = StyleConstants.defaultBaseAppFontSizeLarge
        }
        let font = UIFont.systemFont(ofSize: fontSize)
        SVProgressHUD.setFont(font)
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.setForegroundColor(UIColor.colorFromHexValue(StyleConstants.colorValueBaseAppBlue))
        SVProgressHUD.setBackgroundColor(.white)
        NetworkActivityIndicatorManager.shared.isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        DodoBarDefaultStyles.hideAfterDelaySeconds = 3
        DodoLabelDefaultStyles.font = font
        DodoBarDefaultStyles.locationTop = false
        window?.rootViewController?.view.dodo.topLayoutGuide = window?.rootViewController?.topLayoutGuide
        window?.rootViewController?.view.dodo.bottomLayoutGuide = window?.rootViewController?.bottomLayoutGuide
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white,
                                                            NSFontAttributeName: font]
        UINavigationBar.appearance().tintColor = .white
        UIBarButtonItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.white,
                                                             NSFontAttributeName: font], for: .normal)
    }
    
    /**
        Configures default business logic used universally.
     
        Parameter launchOptions: A `[UIApplicationLaunchOptionsKey: Any]`
                                 representing the launch options received
                                 from the app delegate.
    */
    fileprivate func configureBusinessLogic(launchOptions: [UIApplicationLaunchOptionsKey: Any]?) {
        Fabric.sharedSDK().debug = false
        Fabric.with([Crashlytics.self()])
        DeepLinkManager.shared.initializeBranchIOSession(launchOptions: launchOptions)
        guard let _ = SessionManager.shared.authorizationToken,
              let user = SessionManager.shared.currentUser.value else { return }
        Crashlytics.sharedInstance().setUserIdentifier("\(user.userId)")
        Crashlytics.sharedInstance().setUserEmail(user.email)
    }
    
    /// Loads the authentication flow.
    @objc fileprivate func loadAuthenticationFlow() {
        let loginViewController = UIStoryboard.loadLoginViewController()
        loginViewController.loginViewModel = LoginViewModel()
        let navigationController = AuthenticationNavigationController(rootViewController: loginViewController)
        let snapshot = (self.window?.snapshotView(afterScreenUpdates: true))!
        navigationController.view.addSubview(snapshot)
        window?.rootViewController = navigationController
        UIView.performRootViewControllerAnimation(snapshot: snapshot)
    }
    
    /// Loads the application flow.
    @objc fileprivate func loadApplicationFlow() {
        let rootController = UIStoryboard.loadInitializeViewController()
        rootController.selectedIndex = TabbarIndex.users.rawValue
        let snapshot = (self.window?.snapshotView(afterScreenUpdates: true))!
        rootController.view.addSubview(snapshot)
        window?.rootViewController = rootController
        UIView.performRootViewControllerAnimation(snapshot: snapshot)
    }
    
    /**
        Loads the forgot password reset flow.
     
        - Note: In `notification` it contains the token
                received from forgot password deeplinking
                in the property `object`.
     
        - Parameter notification: A `Notification` representing
                                  the notification that was fired
                                  for forgot password deep linking.
    */
    @objc fileprivate func loadForgotPasswordResetFlow(notification: Notification) {
        guard let token = notification.object as? String else { return }
        let rootViewController = UIStoryboard.loadForgotPasswordResetViewController()
        let forgotPasswordViewModel = ForgotPasswordViewModel(token: token)
        rootViewController.forgotPasswordViewModel = forgotPasswordViewModel
        let navigationController = AuthenticationNavigationController(rootViewController: rootViewController)
        let snapshot = (self.window?.snapshotView(afterScreenUpdates: true))!
        navigationController.view.addSubview(snapshot)
        window?.rootViewController = navigationController
        UIView.performRootViewControllerAnimation(snapshot: snapshot)
    }
}
