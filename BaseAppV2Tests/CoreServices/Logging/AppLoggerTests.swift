//
//  AppLoggerTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/7/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
import SwiftyBeaver
@testable import BaseAppV2

final class AppLoggerTests: BaseAppV2Tests {
    
    // MARK: - Private Instance Attributes
    fileprivate var _appLogger: AppLogger!
}


// MARK: - Setup & Tear Down
extension AppLoggerTests {
    override func setUp() {
        super.setUp()
        _appLogger = AppLogger.shared
    }
    
    override func tearDown() {
        super.tearDown()
        _appLogger = nil
    }
}


// MARK: - Functional Tests
extension AppLoggerTests {
    func testLogMessage() {
        _appLogger.logMessage("Test Error Description", for: .error)
        // Load file that stores log to test if logged successful
        // There are some asumptions that we can make from inspecting
        // SwiftyBeaver's source code:
        // 1) When using the standard cache directory of the application,
        //    the path to the file is always the same.
        // 2) Filename by default is `swiftybeaver.log`.
        // 3) The message sent is always appended at the second to last line. The
        //    last line has a newline character.
        // 4) When running in an test environment, we change the format to
        //    only save the message with no time stamp or level type.
        let fileManager = FileManager.default
        guard let url = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            XCTFail("Error Getting File For Logger Test!")
            return
        }
        let logUrl = url.appendingPathComponent("swiftybeaver.log")
        do {
            let stringData = try String(contentsOf: logUrl)
            let logStrings = stringData.components(separatedBy: .newlines)
            let lastLogEntered = logStrings[logStrings.count - 2]
            XCTAssertEqual(lastLogEntered, "Test Error Description", "Logging Failed!")
        } catch {
            XCTFail("Error Validating Logger Test!")
        }
    }
}
