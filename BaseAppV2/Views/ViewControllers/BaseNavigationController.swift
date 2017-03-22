//
//  BaseNavigationController.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/14/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import KYNavigationProgress

/**
    A base class for having suclasses
    of `UINavigationController`. It also
    defines and sets default attributes for
    an instance.
*/
class BaseNavigationController: UINavigationController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        let navigationBarBackgroundImage = #imageLiteral(resourceName: "background-baseapp")
        navigationBar.setBackgroundImage(navigationBarBackgroundImage, for: .default)
        progressTintColor = .white
    }
}
