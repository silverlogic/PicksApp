//
//  Group.swift
//  BaseAppV2
//
//  Created by Michael Sevy on 5/15/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import CoreData

/**
    A class entity representing a group in the application.
 */
final class Group: NSManagedObject {

    // MARK: - Public Instance Attributes
    @NSManaged var groupId: Int16
    @NSManaged var name: String
    @NSManaged var creatorId: Int16
    @NSManaged var participants: [Int16]?
    @NSManaged var isPrivate: Bool
}


// MARK: - Public Instance Methods
extension Group {

    /**
        Gets the total number of participants in
        the group. This also includes the creator.
     
        - Returns: An `Int` representing the total number
                   of participants in the group.
    */
    func numberOfParticipants() -> Int {
        guard let participants = participants else { return 1 }
        return participants.count + 1
    }
}


//Mark: - Public Class Methods
extension Group {

    /**
        Gets a fetch request for all `Group` entity objects.

        - Returns: A `NSFetchRequest<Groups>` representing a fetch request
                   for all `Group` objects
    */
    @nonobjc public class func allGroupsFetchRequest() -> NSFetchRequest<Group> {
        return NSFetchRequest<Group>(entityName: Group.entityName)
    }

    /**
        Gets a fetch request for a specific `Group` entity object.

        - Parameter groupId: An `Int` representing the Id of the group
                             to retrieve.

        - Returns: A `NSFetchRequest<Group>` encapsulating all the information
                   needed for fetching a specific group.
     */
    @nonobjc public class func specificGroupFetchRequest(groupId: Int) -> NSFetchRequest<Group> {
        let fetchRequest = NSFetchRequest<Group>(entityName: Group.entityName)
        fetchRequest.predicate = NSPredicate(format: "groupId == %d", groupId)
        return fetchRequest
    }
    
    /**
        Gets a fetch request for all `Group` entity objects that will be
        sorted.

        - Parameters:
            - keyPath: A `String` representing the key path or property
                       name to sort by. The key path given needs to be
                       an existing property name of a `Group`.
            - ascending: A `Bool` indicating if the objects needed to be
                         in ascending order or not.

        - Returns: A `NSFetchRequest<Group>` encapsulating all the information
                   needed for fetching `Group` objects. If an invalid key path
                   was given to `keyPath`, `nil` will be returned.
     */
    @nonobjc public class func allGroupsFetchRequest(keyPath: String, ascending: Bool) -> NSFetchRequest<Group>? {
        let fetchRequest = NSFetchRequest<Group>(entityName: Group.entityName)
        if keyPath == #keyPath(Group.groupId) ||
            keyPath == #keyPath(Group.creatorId) ||
            keyPath == #keyPath(Group.participants) ||
            keyPath == #keyPath(Group.isPrivate) ||
            keyPath == #keyPath(Group.name) {
            let sortDescriptor = NSSortDescriptor(key: keyPath, ascending: ascending)
            fetchRequest.sortDescriptors = [sortDescriptor]
            return fetchRequest
        }
        return nil
    }

    /**
        Gets a fetch request for a specific `Group` entity object based on
        a given name.
     
        - Parameter name: A `String` representing the name of the group.
     
        - Returns: A `NSFetchRequest<Group>` encapsulating all the information
                   needed for fetching a specific group.
    */
    @nonobjc public class func specificGroupFetchRequest(groupName: String) -> NSFetchRequest<Group> {
        let fetchRequest = NSFetchRequest<Group>(entityName: Group.entityName)
        fetchRequest.predicate = NSPredicate(format: "name == %@", groupName)
        return fetchRequest
    }
}
