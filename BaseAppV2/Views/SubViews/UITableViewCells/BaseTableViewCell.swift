//
//  BaseTableViewCell.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/17/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import SwipeCellKit

/**
    A base class for having subclasses of
    `UITableViewCell`. It also defines and
    sets default attributes for an instance.
*/
class BaseTableViewCell: SwipeTableViewCell {
    
    // MARK: - Private Class Attributes
    fileprivate static var cellHeight: CGFloat = 44.0
}


// MARK: - Public Class Methods
extension BaseTableViewCell {
    
    /**
        Gets the height of the cell.
     
        - Returns: A `CGFloat` representing the height of
                   the cell.
    */
    open class func height() -> CGFloat {
        return cellHeight
    }

    /**
        Initializes an instance of a swipable action array

            - Returns: A [SwipeAction] with a delete as a defulat
     */
    open class func swipeActions() -> [SwipeAction] {
        let deleteAction = SwipeAction(style: .destructive, title: NSLocalizedString("SwipeCell.Delete", comment: "string for delete action")) { action, indexPath in
            print("send action to binder or viewController")
        }
        return [deleteAction]
    }
}
