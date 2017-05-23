//
//  GroupListSectionHeader.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 5/9/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A subclass of `BaseView`. It is responsible
    for displaying a section header for a table view
    in the group flow.
*/
final class GroupSectionHeader: BaseView, NibLoadableView {
    
    // MARK: - IBOutlets
    @IBOutlet fileprivate weak var columnOneLabel: UILabel!
    @IBOutlet fileprivate weak var columnTwoLabel: UILabel!
}


// MARK: - Public Instance Methods
extension GroupSectionHeader {
    
    /**
        Configures the view with the given strings.
     
        - Parameters:
            - columnOneText: A `String` representing the text
                             to display in the first column.
            - columnTwoText: A `String` representing the text
                             to display in the second column.
    */
    func configure(columnOneText: String, columnTwoText: String) {
        columnOneLabel.text = columnOneText
        columnTwoLabel.text = columnTwoText
    }
}
