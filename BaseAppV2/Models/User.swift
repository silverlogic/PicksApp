//
//  User.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/2/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import CoreData

/**
    A class entity representing a user of the application.
*/
final class User: NSManagedObject {
    
    // MARK: - Private Instance Attributes
    @NSManaged fileprivate var avatar: String?
    
    
    // MARK: - Public Instance Attributes
    @NSManaged var userId: Int16
    @NSManaged var email: String?
    @NSManaged var emailConfirmed: Bool
    @NSManaged var newEmail: String?
    @NSManaged var newEmailConfirmed: Bool
    @NSManaged var referralCode: String?
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
}


// MARK: - Getters & Setters
extension User {
    
    /**
        The url of the user's avatar. If there isn't
        a url, `nil` will be returned.
    */
    var avatarUrl: URL? {
        get {
            guard let stringUrl = avatar,
                  let avatarUrl = URL(string: stringUrl) else {
                return nil
            }
            return avatarUrl
        }
        set {
            guard let url = newValue else {
                return
            }
            avatar = url.absoluteString
        }
    }
}


// MARK: - Public Instance Methods
extension User {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User");
    }
}
