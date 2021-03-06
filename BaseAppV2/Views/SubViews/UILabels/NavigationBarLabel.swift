//
//  NavigationBarLabel.swift
//  BaseAppV2
//
//  Created by Michael Sevy on 5/24/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import UIKit

/**
    A custom Navigation Bar Label with
    images braketing a text string
 */
class NavigationBarLabel: BaseLabel {

    // Public Instance Methods

    /**
        A function that defines a label for the navigation
        bar that also has left and right bar button items
     */
    init(frame: CGRect, name: String) {
        super.init(frame: frame)
        adjustsFontSizeToFitWidth = true
        font = UIFont.main(DefaultFonts.bold, DefaultFontSizes.large)
        textColor = UIColor.white
        let title = NSMutableAttributedString()
        let starAttachment = NSTextAttachment()
        starAttachment.image = #imageLiteral(resourceName: "icon-star")
        let starImage = NSAttributedString(attachment: starAttachment)
        title.append(starImage)
        title.append(NSAttributedString(string: " "))
        title.append(NSAttributedString(string: name))
        title.append(NSAttributedString(string: " "))
        title.append(starImage)
        textAlignment = .center
        attributedText = title
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
