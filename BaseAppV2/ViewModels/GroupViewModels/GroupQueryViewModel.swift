//
//  GroupQueryViewModel.swift
//  BaseAppV2
//
//  Created by Michael Sevy on 5/16/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A protocol for defining state and behavior
    for querying a group.
 */
protocol GroupQueryViewModelProtocol: class {

    // MARK: - Public Instance Attributes
    var groupsFetched: DynamicBinderInterface<Bool> { get }
    var fetchGroupsError: DynamicBinderInterface<BaseError?> { get }
    var joinError: DynamicBinderInterface<BaseError?> { get }
    var joinSuccess: DynamicBinderInterface<Bool> { get }

    // MARK: - Instance Methods
    func fetchGroupsForUser(userId: Int16)
    func fetchAllGroups()
    func groupForIndex(_ index: Int) -> GroupDetailViewModelProtocol?
    func numberOfGroups() -> Int
    func joinGroup(currentUserId: Int16, groupId: Int16)
}


/**
    A `ViewModelManager` class extension for `GroupQueryViewModelProtocol`.
*/
extension ViewModelsManager {

    /**
        Allocates and returns an instance of `GroupQueryViewModelProtocol`
        for fetching the groups the current user creator or is
        participating in.

        - Returns: An instance conforming to `GroupQueryViewModelProtocol`.
    */
    class func groupQueryForCurrentUserViewModel() -> GroupQueryViewModelProtocol {
        return GroupQueryForCurrentUserViewModel()
    }

    /**
        Allocates and returns an instance of `GroupQueryViewModelProtocol`
        for fethcing public groups.
     
        - Returns: An instance conforming to `GroupQueryViewModelProtocol`.
    */
    class func groupQueryForPublicGroupsViewModel() -> GroupQueryViewModelProtocol {
        return GroupQueryForPublicGroupsViewModel()
    }
}


/**
    A class that conforms to `GroupQueryViewModelProtocol`
    and implements it.
*/
fileprivate final class GroupQueryForCurrentUserViewModel: GroupQueryViewModelProtocol {

    // MARK: - GroupQueryViewModelProtocol Attributes
    var fetchGroupsError: DynamicBinderInterface<BaseError?> {
        return fetchGroupsErrorBinder.interface
    }
    var groupsFetched: DynamicBinderInterface<Bool> {
        return groupsFetchedBinder.interface
    }
    var joinError: DynamicBinderInterface<BaseError?> {
        return joinErrorBinder.interface
    }
    var joinSuccess: DynamicBinderInterface<Bool> {
        return joinSuccessBinder.interface
    }


    // MARK: - Private Instance Attributes
    private var groupsFetchedBinder: DynamicBinder<Bool>
    private var fetchGroupsErrorBinder: DynamicBinder<BaseError?>
    private var groups: [GroupDetailViewModelProtocol]
    private var joinSuccessBinder: DynamicBinder<Bool>
    private var joinErrorBinder: DynamicBinder<BaseError?>
    

    // MARK: - Initializers

    /// Initializes an instance of `GroupQueryForCurrentUserViewModel`.
    init() {
        groups = [GroupDetailViewModelProtocol]()
        groupsFetchedBinder = DynamicBinder(false)
        fetchGroupsErrorBinder = DynamicBinder(nil)
        joinErrorBinder = DynamicBinder(nil)
        joinSuccessBinder = DynamicBinder(false)
    }


    // MARK: - GroupQueryViewModelProtocol Methods
    func groupForIndex(_ index: Int) -> GroupDetailViewModelProtocol? {
        return groups[safe: index]
    }

    func fetchGroupsForUser(userId: Int16) {
        GroupManager.shared.fetchGroupsForCreator(userId: userId, success: { (creatorGroups) in
            GroupManager.shared.fetchGroupsForParticipant(userId: userId, success: { [weak self] (participantGroups) in
                guard let strongSelf = self else { return }
                strongSelf.groups.removeAll()
                let allGroupsForUser = creatorGroups + participantGroups
                let sortedGroup = allGroupsForUser.sorted(by: {$0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending })
                for group in sortedGroup {
                    strongSelf.groups.append(ViewModelsManager.groupDetailViewModel(group: group))
                }
                strongSelf.groupsFetchedBinder.value = true
            }, failure: { [weak self] (participantError) in
                guard let strongSelf = self else { return }
                strongSelf.fetchGroupsErrorBinder.value = participantError
            })
        }) { [weak self] (error) in
            guard let strongSelf = self else { return }
            strongSelf.fetchGroupsErrorBinder.value = error
        }
    }

    func fetchAllGroups() {
        GroupManager.shared.fetchAllGroups(success: { [weak self] (fetchedGroups) in
            guard let strongSelf = self else { return }
            strongSelf.groups.removeAll()
            let sorted = fetchedGroups.sorted(by: {$0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending})
            for group in sorted {
                strongSelf.groups.append(ViewModelsManager.groupDetailViewModel(group: group))
            }
            strongSelf.groupsFetchedBinder.value = true
        }) { [weak self] (error) in
            guard let strongSelf = self else { return }
            strongSelf.fetchGroupsErrorBinder.value = error
        }
    }

    func numberOfGroups() -> Int {
        return groups.count
    }

    func joinGroup(currentUserId: Int16, groupId: Int16) {
        GroupManager.shared.joinGroup(currentUserId: currentUserId, groupId: groupId, success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.joinSuccessBinder.value = true
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            strongSelf.joinErrorBinder.value = error
        }
    }
}


/**
    A class that conforms to `GroupQueryViewModelProtocol`
    and implements it.
*/
fileprivate final class GroupQueryForPublicGroupsViewModel: GroupQueryViewModelProtocol {

    // MARK: - GroupQueryViewModelProtocol Attributes
    var fetchGroupsError: DynamicBinderInterface<BaseError?> {
        return fetchGroupsErrorBinder.interface
    }
    var groupsFetched: DynamicBinderInterface<Bool> {
        return groupsFetchedBinder.interface
    }
    var joinError: DynamicBinderInterface<BaseError?> {
        return joinErrorBinder.interface
    }
    var joinSuccess: DynamicBinderInterface<Bool> {
        return joinSuccessBinder.interface
    }


    // MARK: - Private Instance Attributes
    private var groupsFetchedBinder: DynamicBinder<Bool>
    private var fetchGroupsErrorBinder: DynamicBinder<BaseError?>
    private var groups: [GroupDetailViewModelProtocol]
    private var joinSuccessBinder: DynamicBinder<Bool>
    private var joinErrorBinder: DynamicBinder<BaseError?>


    // MARK: - Initializers

    /// Initializes an instance of `GroupQueryForPublicGroupsViewModel`.
    init() {
        groups = [GroupDetailViewModelProtocol]()
        groupsFetchedBinder = DynamicBinder(false)
        fetchGroupsErrorBinder = DynamicBinder(nil)
        joinErrorBinder = DynamicBinder(nil)
        joinSuccessBinder = DynamicBinder(false)
    }


    // MARK: - GroupQueryViewModelProtocol Methods
    func groupForIndex(_ index: Int) -> GroupDetailViewModelProtocol? {
        return groups[safe: index]
    }

    func fetchAllGroups() {
        GroupManager.shared.fetchAllGroups(success: { [weak self] (fetchedGroups) in
            guard let strongSelf = self else { return }
            strongSelf.groups.removeAll()
            let sorted = fetchedGroups.sorted(by: {$0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending})
            for group in sorted {
                strongSelf.groups.append(ViewModelsManager.groupDetailViewModel(group: group))
            }
            strongSelf.groupsFetchedBinder.value = true
        }) { [weak self] (error) in
            guard let strongSelf = self else { return }
            strongSelf.fetchGroupsErrorBinder.value = error
        }
    }

    func fetchGroupsForUser(userId: Int16) {
        GroupManager.shared.fetchGroupsForCreator(userId: userId, success: { (creatorGroups) in
            GroupManager.shared.fetchGroupsForParticipant(userId: userId, success: { [weak self] (participantGroups) in
                guard let strongSelf = self else { return }
                strongSelf.groups.removeAll()
                let allGroupsForUser = creatorGroups + participantGroups
                let sortedGroup = allGroupsForUser.sorted(by: {$0.name.localizedCaseInsensitiveCompare($1.name) == ComparisonResult.orderedAscending })
                for group in sortedGroup {
                    strongSelf.groups.append(ViewModelsManager.groupDetailViewModel(group: group))
                }
                strongSelf.groupsFetchedBinder.value = true
                }, failure: { [weak self] (participantError) in
                    guard let strongSelf = self else { return }
                    strongSelf.fetchGroupsErrorBinder.value = participantError
            })
        }) { [weak self] (error) in
            guard let strongSelf = self else { return }
            strongSelf.fetchGroupsErrorBinder.value = error
        }
    }

    func numberOfGroups() -> Int {
        return groups.count
    }

    func joinGroup(currentUserId: Int16, groupId: Int16) {
        GroupManager.shared.joinGroup(currentUserId: currentUserId, groupId: groupId, success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.joinSuccessBinder.value = true
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            strongSelf.joinErrorBinder.value = error
        }
    }
}
