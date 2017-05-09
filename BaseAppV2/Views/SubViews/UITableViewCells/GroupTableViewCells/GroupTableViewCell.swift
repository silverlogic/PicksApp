//
//  GroupListTableViewCell.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 5/9/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A `BaseTableViewCell` responsible for handling
    and configuring the view when displaying the name
    of a group and the number of members the group
    contains.
*/
final class GroupTableViewCell: BaseTableViewCell, NibLoadableView {
    
    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var nameLabel: BaseLabel!
    @IBOutlet fileprivate weak var numberLabel: BaseLabel!
    
    
    // MARK: - Private Instance Attributes
    fileprivate static let cellHeight: CGFloat = 66.0
}


// MARK: - Public Instance Methods
extension GroupTableViewCell {
    
    /**
        Configures the view of a group cell.
     
        - Parameters:
            - name: A `String`. This value would represent the name of a
                    group or the name of a person in the group.
            - number: A `Int`. This value would represent the number of
                      people in a group or the number of points a person
                      has.
            - backgroundColor: A `UIColor` representing the color to set
                               to the background.
    */
    func configure(groupName: String, numberOfMembers: Int, backgroundColor: UIColor) {
        nameLabel.text = groupName
        numberLabel.text = "\(numberOfMembers)"
        self.backgroundColor = backgroundColor
    }
}


// MARK: - Public Class Methods
extension GroupTableViewCell {
    override class func height() -> CGFloat {
        return cellHeight
    }
}
