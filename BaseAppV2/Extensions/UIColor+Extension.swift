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
    
    /// Color used for the tabbar in the application.
    static var tabbar: UIColor { return colorFromHexValue(tabbarHexValue) }
    
    /// Color used for showing the light green field in the application.
    static var lightGreenField: UIColor { return colorFromHexValue(fieldHexValue, alpha: 0.15) }
    
    /// Color used for showing the dark green field in the application.
    static var darkGreenField: UIColor { return colorFromHexValue(fieldHexValue, alpha: 0.3) }
    
    /// Text color used in the application.
    static var text: UIColor { return colorFromHexValue(textHexValue) }
}


// MARK: - Hex Value Constants
extension UIColor {
    @nonobjc static var mainHexValue: UInt = 0x003399
    @nonobjc static var secondaryHexValue: UInt = 0xFFFFFF
    @nonobjc static var teritaryHexValue: UInt = 0x8B0F04
    @nonobjc static var tabbarHexValue: UInt = 0xE8E8E8
    @nonobjc static var fieldHexValue: UInt = 0x003300
    @nonobjc static var textHexValue: UInt = 0x4A4A4A
}
