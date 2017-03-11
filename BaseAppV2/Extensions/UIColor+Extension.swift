//
//  UIColor+Extension.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/9/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

extension UIColor {
    
    /**
        Gets the color from a given hexidecimal value.
     
        - Parameter hexValue: An `UInt` representing the hexidecimal value
     
        - Returns: An `UIColor` object containing the color generated from `hexValue`.
    */
    static func colorFromHexValue(_ hexValue: UInt) -> UIColor {
        let redValue = ((Float)((hexValue & 0xFF0000) >> 16)) / 255.0
        let greenValue = ((Float)((hexValue & 0xFF00) >> 8)) / 255.0
        let blueValue = ((Float)(hexValue & 0xFF)) / 255.0
        return UIColor(colorLiteralRed: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
    }
}
