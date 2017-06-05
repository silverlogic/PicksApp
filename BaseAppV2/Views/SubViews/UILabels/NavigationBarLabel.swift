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
    func label(viewModel: GroupDetailViewModelProtocol, viewController: UIViewController) -> (UILabel) {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: (viewController.navigationController?.view.bounds.size.width)!, height: 77.0))
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.main(DefaultFonts.bold, DefaultFontSizes.large)
        label.textColor = UIColor.white
        let title = NSMutableAttributedString()
        let starAttachment = NSTextAttachment()
        starAttachment.image = #imageLiteral(resourceName: "icon-star")
        let starImage = NSAttributedString(attachment: starAttachment)
        title.append(starImage)
        title.append(NSAttributedString(string: " "))
        title.append(NSAttributedString(string: viewModel.name))
        title.append(NSAttributedString(string: " "))
        title.append(starImage)
        label.textAlignment = .center
        label.attributedText = title
        return label
    }
}
