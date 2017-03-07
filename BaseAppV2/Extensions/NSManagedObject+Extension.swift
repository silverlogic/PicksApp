//
//  NSManagedObject+Extension.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/7/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    
    /// The string representation of the class name.
    static var entityName: String {
        return String(describing: self)
    }
}
