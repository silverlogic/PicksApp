//
//  UIColor+Extension.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/9/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

// MARK: - Private Class Methods
fileprivate extension UIColor {
    
    /**
        Gets the color from a given hexidecimal value.
     
        - Parameters:
            - hexValue: An `UInt` representing the hexidecimal value.
            - alpha: A `Float` representing how much alpha to apply.
                     Default value is 1.0.
     
        - Returns: An `UIColor` object containing the color generated from `hexValue`.
    */
    fileprivate static func colorFromHexValue(_ hexValue: UInt, alpha: Float = 1.0) -> UIColor {
        let redValue = ((Float)((hexValue & 0xFF0000) >> 16)) / 255.0
        let greenValue = ((Float)((hexValue & 0xFF00) >> 8)) / 255.0
        let blueValue = ((Float)(hexValue & 0xFF)) / 255.0
        return UIColor(colorLiteralRed: redValue, green: greenValue, blue: blueValue, alpha: alpha)
    }
}


// MARK: - Application Colors
extension UIColor {
    
    /// Main color used in the application.
    static var main: UIColor { return colorFromHexValue(mainHexValue) }
    
    /// Secondary color used in the application.
    static var secondary: UIColor { return colorFromHexValue(secondaryHexValue) }
    
    /// Teritary color used in the application.
    static var teritary: UIColor { return colorFromHexValue(teritaryHexValue) }
}


// MARK: - Hex Value Constants
extension UIColor {
    @nonobjc static var mainHexValue: UInt = 0x3D8DD4
    @nonobjc static var secondaryHexValue: UInt = 0xFFFFFF
    @nonobjc static var teritaryHexValue: UInt = 0xFFFFFF
}
