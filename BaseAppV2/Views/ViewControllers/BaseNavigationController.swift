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
    A base class for having subclasses
    of `UINavigationController`. It also
    defines and sets default attributes for
    an instance.
*/
class BaseNavigationController: UINavigationController {
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        navigationBar.barTintColor = .main
        progressTintColor = .white
    }
}
