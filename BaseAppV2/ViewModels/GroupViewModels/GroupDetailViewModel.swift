//
//  GroupDetailViewModel.swift
//  BaseAppV2
//
//  Created by Michael Sevy on 5/18/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A protocol for defining state and behavior
    for retrieving the details of a group.
*/
protocol GroupDetailViewModelProtocol {

    // MARK: - Instance Attributes
    var name: String { get }
    var groupId: Int16 { get }
    var participants: [Int16]? { get }
    var joinError: DynamicBinderInterface<BaseError?> { get }
    var joinSuccess: DynamicBinderInterface<Bool> { get }

    
    // MARK: - Instance Methods
    func participantForIndex(_ index: Int) -> (name: String, score: Int)
    func numberOfParticipants() -> Int
    func joinGroup(groupId: Int16)
    func joinPrivateGroup(groupId: Int16, code: String)
    func isUserMember() -> Bool
}


/**
    A `ViewModelManager` class extension for `GroupDetailViewModelProtocol`.
*/
extension ViewModelsManager { 

    /**
        Allocates and returns an instance of `GroupDetailViewModelProtocol`.
     
        - Parameter group: A `Group` representing a group with participants
        
        - Returns: An instance conforming to `GroupDetailViewModelProtocol`.
    */
    class func groupDetailViewModel(group: Group) -> GroupDetailViewModelProtocol {
        return GroupDetailViewModel(group: group)
    }
}


/**
    A class that conforms to `GroupDetailViewModelProtocol`
    and implements it.
*/
fileprivate final class GroupDetailViewModel: GroupDetailViewModelProtocol {

    // MARK: - GroupDetailViewModelProtocol Attributes
    var name: String
    var groupId: Int16
    var participants: [Int16]?
    var joinError: DynamicBinderInterface<BaseError?> {
        return joinErrorBinder.interface
    }
    var joinSuccess: DynamicBinderInterface<Bool> {
        return joinSuccessBinder.interface
    }


    // MARK: - Private Instance Attributes
    private var group: Group
    private var joinSuccessBinder: DynamicBinder<Bool>
    private var joinErrorBinder: DynamicBinder<BaseError?>

    
    // MARK: - Initializers

    /**
        Initializes an instance of `GroupDetailViewModel`.
     
        - Parameter group: A `Group` representing a group
                           of participants.
    */
    init(group: Group) {
        self.group = group
        name = self.group.name
        groupId = self.group.groupId
        participants = self.group.participants
        joinErrorBinder = DynamicBinder(nil)
        joinSuccessBinder = DynamicBinder(false)
    }


    // MARK: - GroupDetailViewModelProtocol Methods
    func participantForIndex(_ index: Int) -> (name: String, score: Int) {
        return ("Johnny Quest", 10)
    }

    func numberOfParticipants() -> Int {
        return group.numberOfParticipants()
    }

    func isUserMember() -> Bool {
        if SessionManager.shared.currentUser.value?.userId == group.creatorId {
            return true
        }
            guard let participants = group.participants else { return false }
            for memberId in participants {
                if SessionManager.shared.currentUser.value?.userId == memberId {
                    return true
                }
            }
            return false
        }

    func joinGroup(groupId: Int16) {
        GroupManager.shared.joinGroup(groupId: groupId, success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.joinSuccessBinder.value = true
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            strongSelf.joinErrorBinder.value = error
        }
    }

    func joinPrivateGroup(groupId: Int16, code: String) {
        // @TODO add private code joining v2
    }
}
