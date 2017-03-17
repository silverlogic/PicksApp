//
//  ReuseableView.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/17/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A protocol for defining resusable
    for different subclasses of `UIView`.
*/
protocol ResuableView {
    
    // MARK: - Class Attributes
    static var reuseIdentifier: String { get }
}


/**
    Provides a default implementation of `reuseIdentifier` for
    instances that conform to `ReusableView` when the type is
    `UIView`
*/
extension ResuableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
