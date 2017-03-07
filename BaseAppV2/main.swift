//
//  main.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/7/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import UIKit

private func delegateClassName() -> String? {
    let environmentDictionary = ProcessInfo.processInfo.environment
    if environmentDictionary["RUNNING_UNIT_TESTS"] == "TRUE" {
        // Use test AppDelegate for unit tests
        return NSStringFromClass(TestAppDelegate.self)
    }
    // Use regular AppDelegate for UI tests and application running
    return NSStringFromClass(AppDelegate.self)
}

UIApplicationMain(CommandLine.argc, UnsafeMutableRawPointer(CommandLine.unsafeArgv).bindMemory(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc)), nil, delegateClassName())
