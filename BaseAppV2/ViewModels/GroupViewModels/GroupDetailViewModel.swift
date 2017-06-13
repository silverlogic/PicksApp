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
    var participantScores: [(name: String, score: Int16)]? { get }
    var currentSeason: Int16 { get }
    var joinError: DynamicBinderInterface<BaseError?> { get }
    var joinSuccess: DynamicBinderInterface<Bool> { get }
    var fetchedParticipantsError: DynamicBinderInterface<BaseError?> { get }
    var fetchedParticipantsSuccess: DynamicBinderInterface<Bool> { get }

    
    // MARK: - Instance Methods
    func participantForIndex(_ index: Int) -> (name: String?, score: Int?)
    func numberOfParticipants() -> Int
    func joinGroup(currentUserId: Int16)
    func joinPrivateGroup(groupId: Int16, code: String)
    func isUserMember() -> Bool
    func retrieveDetails(currentUser: User)
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
    var participantScores: [(name: String, score: Int16)]?
    var currentSeason: Int16
    var joinError: DynamicBinderInterface<BaseError?> {
        return joinErrorBinder.interface
    }
    var joinSuccess: DynamicBinderInterface<Bool> {
        return joinSuccessBinder.interface
    }
    var fetchedParticipantsError: DynamicBinderInterface<BaseError?> {
        return fetchedParticipantsErrorBinder.interface
    }
    var fetchedParticipantsSuccess: DynamicBinderInterface<Bool> {
        return fetchedParticipantsSuccessBinder.interface
    }


    // MARK: - Private Instance Attributes
    private var group: Group
    private var joinSuccessBinder: DynamicBinder<Bool>
    private var joinErrorBinder: DynamicBinder<BaseError?>
    private var fetchedParticipantsSuccessBinder: DynamicBinder<Bool>
    private var fetchedParticipantsErrorBinder: DynamicBinder<BaseError?>

    
    // MARK: - Initializers

    /**
    ///Initializes an instance of `GroupDetailViewModel`.
     
        - Parameter group: A `Group` representing a group of participants.
    */
    init(group: Group) {
        self.group = group
        name = self.group.name
        groupId = self.group.groupId
        participantScores = []
        currentSeason = self.group.currentSeason
        joinErrorBinder = DynamicBinder(nil)
        joinSuccessBinder = DynamicBinder(false)
        fetchedParticipantsSuccessBinder = DynamicBinder(false)
        fetchedParticipantsErrorBinder = DynamicBinder(nil)
    }


    // MARK: - GroupDetailViewModelProtocol Methods
    func participantForIndex(_ index: Int) -> (name: String?, score: Int?) {
        guard let participants = participantScores else { return (nil, nil) }
        if participants.count > 0 {
            return (name: participants[index].name, score: Int(participants[index].score))
        }
        return (nil, nil)
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

    func joinGroup(currentUserId: Int16) {
        GroupManager.shared.joinGroup(currentUserId: currentUserId, groupId: groupId, success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.joinSuccessBinder.value = true
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            strongSelf.joinErrorBinder.value = error
        }
    }

    func retrieveDetails(currentUser: User) {
        GroupManager.shared.fetchParticipantsForGroup(groupId: groupId, success: { [weak self] (participants) in
            guard let strongSelf = self else { return }
            SeasonManager.shared.scoresForSeason(seasonId: strongSelf.currentSeason, success: { [weak self] (scores: [Score]) in
                guard let strongSelf = self else { return }
                strongSelf.participantScores?.removeAll()
                var participantsPlusCreator = participants
                if currentUser.userId == strongSelf.group.creatorId {
                    participantsPlusCreator.append(currentUser)
                    let sortedScores = scores.sorted(by: { ($0.participantId < $1.participantId) })
                    let sortedParticipants = participantsPlusCreator.sorted(by: { ($0.userId < $1.userId) })
                    for username in sortedParticipants {
                        for score in sortedScores {
                            if username.userId == score.participantId {
                                strongSelf.participantScores?.append((name: username.fullName, score: score.score))
                            }
                        }
                    }
                    strongSelf.participantScores = (strongSelf.participantScores?.sorted(by: { ($0.score < $1.score) }))
                    strongSelf.fetchedParticipantsSuccessBinder.value = true
                } else {
                    UserManager.shared.retrieveUser(userId: Int(strongSelf.group.creatorId), success: { [weak self] (user) in
                        guard let strongSelf = self else { return }
                        participantsPlusCreator.append(user)
                        let sortedScores = scores.sorted(by: { ($0.participantId < $1.participantId) })
                        let sortedParticipants = participantsPlusCreator.sorted(by: { ($0.userId < $1.userId) })
                        for username in sortedParticipants {
                            for score in sortedScores {
                                if username.userId == score.participantId {
                                    strongSelf.participantScores?.append((name: username.fullName, score: score.score))
                                }
                            }
                        }
                        strongSelf.participantScores = (strongSelf.participantScores?.sorted(by: { ($0.score < $1.score) }))
                        strongSelf.fetchedParticipantsSuccessBinder.value = true
                    }, failure: { [weak self] (error) in
                        guard let strongSelf = self else { return }
                        strongSelf.fetchedParticipantsErrorBinder.value = error
                    })
                }
            }, failure: { [weak self] (error) in
                guard let strongSelf = self else { return }
                strongSelf.fetchedParticipantsErrorBinder.value = error
            })
        }, failure: { [weak self] (error) in
            guard let strongSelf = self else { return }
            strongSelf.fetchedParticipantsErrorBinder.value = error
        })
    }

    func joinPrivateGroup(groupId: Int16, code: String) {
        // @TODO add private code joining v2
    }
}
