//
//  NavigationView.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 5/8/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A subclass of `BaseView`. It is responsible
    for configuring a custom top item to place
    in the navigation bar.
*/
final class NavigationView: BaseView {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var titleLabel: UILabel!
    
    
    // MARK: - Public Instance Attributes
    var titleText: String = "" {
        didSet {
            titleLabel.text = titleText.uppercased()
            let width = titleLabel.frame.size.width + (32.0 * 2)
            frame = CGRect(x: 0, y: 0, width: width, height: 77.0)
        }
    }
}


// MARK: - NibLoadableView
extension NavigationView: NibLoadableView {}
