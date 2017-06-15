//
//  GroupManager.swift
//  BaseAppV2
//
//  Created by Michael Sevy on 5/16/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import AlamofireCoreData

/**
    A singleton responsible for the Group class.
 */
final class GroupManager {

    // MARK: - Shared Instance
    static let shared = GroupManager()


    /// Initializes a shared instance of `GroupManager`.
    private init() {}
}


// MARK: - Public Instance Methods
extension GroupManager {

    /**
        Fetches the Groups the current user belongs to.
     
        - Parameters:
            - success: A closure that gets invoked when the getting the
                       user's group/s and returns an array of groups.
            - failure: A closure that gets invoked when getting the
                       users's group/s fails. Passes a 'BaseError`
                       object containing the error that occured.
     */
    func fetchGroupsForParticipant(userId: Int16, success: @escaping (_ groups: [Group]) -> Void, failure: @escaping (_ error: BaseError) -> Void) {
        let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
        dispatchQueue.async {
            let networkClient = NetworkClient(baseUrl: ConfigurationManager.shared.apiUrl!, manageObjectContext: CoreDataStack.shared.managedObjectContext)
            networkClient.enqueue(GroupEndpoint.groupsParticipant(participantId: userId, isPrivate: false))
            .then(on: DispatchQueue.main, execute: { (groups: Many<Group>) -> Void in
                success(groups.array)
            })
            .catchAPIError(on: DispatchQueue.main, policy: .allErrors, execute: { (error: BaseError) in
                failure(error)
            })
        }
    }

    /**
        Fetches the Group/s that belong to the group creator.

        - Parameters:
            - success: A closure that gets invoked when the getting the
                       creator's group/s and returns an array of groups.
            - failure: A closure that gets invoked when getting the
                       creators's group/s fails. Passes a 'BaseError`
                       object containing the error that occured.
     */
    func fetchGroupsForCreator(userId: Int16, success: @escaping (_ groups: [Group]) -> Void, failure: @escaping (_ error: BaseError) -> Void) {
        let dispathQueue = DispatchQueue.global(qos: .userInitiated)
        dispathQueue.async {
            let networkClient = NetworkClient(baseUrl: ConfigurationManager.shared.apiUrl!, manageObjectContext: CoreDataStack.shared.managedObjectContext)
            networkClient.enqueue(GroupEndpoint.groupsCreator(creatorId: userId, isPrivate: false))
            .then(on: DispatchQueue.main, execute: { (groups: Many<Group>) -> Void in
                success(groups.array)
            })
            .catchAPIError(on: DispatchQueue.main, policy: .allErrors, execute: { (error: BaseError) in
                failure(error)
            })
        }
    }

    /**
        Fetches all public Groups.

        - Parameters:
            - success: A closure that gets invoked when the getting all
                       public groups and returns an array of groups.
            - failure: A closure that gets invoked when getting all
                       groups fails. Passes a 'BaseError`
                       object containing the error that occured.
     */
    func fetchAllGroups(success: @escaping (_ groups: [Group]) -> Void, failure: @escaping (_ error: BaseError) -> Void) {
        let dispathQueue = DispatchQueue.global(qos: .userInitiated)
        dispathQueue.async {
            let networkClient = NetworkClient(baseUrl: ConfigurationManager.shared.apiUrl!, manageObjectContext: CoreDataStack.shared.managedObjectContext)
            networkClient.enqueue(GroupEndpoint.groupsParticipant(participantId:nil , isPrivate: false))
            .then(on: DispatchQueue.main, execute: { (groups: Many<Group>) -> Void in
                success(groups.array)
            })
            .catchAPIError(on: DispatchQueue.main, policy: .allErrors, execute: { (error: BaseError) in
                failure(error)
            })
        }
    }

    /**
        Creates a public Group.

        - Parameters:
            - name: A `String` representing the name of the Group to be created.
            - creatorId: A `Number` of the creatorid whom creates the group.
            - success: A closure that gets invoked when sending the
                       request was successful.
            - failure: A closure that gets invoked when sending the
                       request failed. Passes a `BaseError` object that
                       contains the error that occured.
     */
    func postGroup(groupName: String, success: @escaping () -> Void, failure: @escaping (_ error: BaseError) -> Void) {
        let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
        dispatchQueue.async {
            let networkClient = NetworkClient(baseUrl: ConfigurationManager.shared.apiUrl!, manageObjectContext: CoreDataStack.shared.managedObjectContext)
            networkClient.enqueue(GroupEndpoint.post(groupName: groupName, creator: SessionManager.shared.currentUser.value!, isPrivate: false))
            .then(on: DispatchQueue.main, execute: { () -> Void in
                success()
            })
            .catchAPIError(on: DispatchQueue.main, policy: .allErrors, execute: { (error: BaseError) in
                failure(error)
            })
        }
    }

    /**
        Joins a public Group.
     
        - Parameters:
            - groupId: A `Int16` representing the Id of the Group to be joined.
            - success: A closure that gets invoked when sending the
                       request was successful.
            - failure: A closure that gets invoked when sending the
                       request failed. Passes a `BaseError` object that
                       contains the error that occured.
     */
    func joinGroup(currentUserId: Int16, groupId: Int16, success: @escaping () -> Void, failure: @escaping (_ error: BaseError) -> Void) {
        let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
        dispatchQueue.async {
            let networkClient = NetworkClient(baseUrl: ConfigurationManager.shared.apiUrl!, manageObjectContext: CoreDataStack.shared.managedObjectContext)
            networkClient.enqueue(GroupEndpoint.join(groupId: groupId, userId: currentUserId))
            .then(on: DispatchQueue.main, execute: { () -> Void in
                success()
            })
            .catchAPIError(on: DispatchQueue.main, policy: .allErrors, execute: { (error: BaseError) in
                failure(error)
            })
        }
    }

    /**
     Fetches all participants(Users) in a Group.

        - Parameters:
            - groupId: A `Int16` representing the Id of the Group.
            - success: A closure that gets invoked when sending the
                       request was successful.
            - failure: A closure that gets invoked when sending the
                       request failed. Passes a `BaseError` object that
                       contains the error that occured.
     */
    func fetchParticipantsForGroup(groupId: Int16, success: @escaping (_ participants: [User]) -> Void, failure: @escaping (_ error: BaseError) -> Void) {
        let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
        dispatchQueue.async {
            let networkClient = NetworkClient(baseUrl: ConfigurationManager.shared.apiUrl!, manageObjectContext: CoreDataStack.shared.managedObjectContext)
            networkClient.enqueue(GroupEndpoint.participantsInGroup(groupId: groupId))
            .then(on: DispatchQueue.main, execute: { (participants: Many<User>) -> Void in
                success(participants.array)
            })
            .catchAPIError(on: DispatchQueue.main, policy: .allErrors, execute: { (error: BaseError) in
                failure(error)
            })
        }
    }
}
