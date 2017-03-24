//
//  BaseTabBarController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/24/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A base class for having subclasses
    of `UITabBarController`. It also defines
    and sets default attributes for an instance
*/
class BaseTabBarController: UITabBarController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let profileViewController = viewControllers?.flatMap({ (viewController: UIViewController) -> ProfileViewController? in
            guard let baseNavigationController = viewController as? BaseNavigationController, baseNavigationController.topViewController is ProfileViewController,
                  let profileViewController = baseNavigationController.topViewController as? ProfileViewController else { return nil }
            return profileViewController
        }).first else {
            return
        }
        profileViewController.profileViewModel = ProfileViewModel(user: SessionManager.shared.currentUser)
    }
}
