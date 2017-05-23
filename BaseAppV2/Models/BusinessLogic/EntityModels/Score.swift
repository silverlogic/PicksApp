//
//  Season.swift
//  BaseAppV2
//
//  Created by Michael Sevy on 5/30/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import CoreData

/**
    A class entity representing a Season in the application.
*/
final class Score: NSManagedObject {

    // MARK: - Public Instance Attributes
    @NSManaged var scoreId: Int16
    @NSManaged var seasonId: Int16
    @NSManaged var score: Int16
    @NSManaged var participantId: Int16
}
