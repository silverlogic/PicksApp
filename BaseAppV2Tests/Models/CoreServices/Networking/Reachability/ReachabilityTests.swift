//
//  ReachabilityTests.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 4/19/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import XCTest
@testable import BaseAppV2

final class ReachabilityTests: BaseAppV2Tests {
    
    // MARK: - Functional Tests
    func testConnectionStatusBinder() {
        let connectionStatusExpectation = expectation(description: "Test Connection Status Listener Being Fired")
        Reachability.shared.connectionStatus.bindAndFire({ (status: ConnectionStatus) in
            connectionStatusExpectation.fulfill()
        }, for: self)
        waitForExpectations(timeout: 10) { (error: Error?) in
            if error != nil {
                XCTFail("Error With Binder!")
                Reachability.shared.connectionStatus.removeListeners(for: self)
                return
            }
            Reachability.shared.connectionStatus.removeListeners(for: self)
        }
    }
    
    func testIsConnected() {
        XCTAssertNotNil(Reachability.shared.isConnected(), "Value Shouldn't Be Nil!")
    }
    
    func testIsConnectedByWifi() {
        XCTAssertNotNil(Reachability.shared.isConnectedByWifi(), "Value Shouldn't Be Nil!")
    }
    
    func testIsConnectByCellNetwork() {
        XCTAssertNotNil(Reachability.shared.isConnectedByCellNetwork(), "Value Shouldn't Be Nil!")
    }
}
