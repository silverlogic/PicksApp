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


    // MARK: - Instance Methods
    func fetchGroups()
    func groupForIndex(_ index: Int) -> GroupDetailViewModelProtocol?
    func numberOfGroups() -> Int
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


    // MARK: - Private Instance Attributes
    private var groupsFetchedBinder: DynamicBinder<Bool>
    private var fetchGroupsErrorBinder: DynamicBinder<BaseError?>
    private var groups: [GroupDetailViewModelProtocol]


    // MARK: - Initializers

    /// Initializes an instance of `GroupQueryForCurrentUserViewModel`.
    init() {
        groups = [GroupDetailViewModelProtocol]()
        groupsFetchedBinder = DynamicBinder(false)
        fetchGroupsErrorBinder = DynamicBinder(nil)
    }


    // MARK: - GroupQueryViewModelProtocol Methods
    func groupForIndex(_ index: Int) -> GroupDetailViewModelProtocol? {
        return groups[safe: index]
    }

    func fetchGroups() {
        GroupManager.shared.fetchGroupsForUserAsCreator(success: { (creatorGroups) in
            GroupManager.shared.fetchGroupsForUserAsParticipant(success: { [weak self] (participantGroups) in
                guard let strongSelf = self else { return }
                strongSelf.groups.removeAll()
                for group in creatorGroups {
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


    // MARK: - Private Instance Attributes
    private var groupsFetchedBinder: DynamicBinder<Bool>
    private var fetchGroupsErrorBinder: DynamicBinder<BaseError?>
    private var groups: [GroupDetailViewModelProtocol]


    // MARK: - Initializers

    /// Initializes an instance of `GroupQueryForPublicGroupsViewModel`.
    init() {
        groups = [GroupDetailViewModelProtocol]()
        groupsFetchedBinder = DynamicBinder(false)
        fetchGroupsErrorBinder = DynamicBinder(nil)
    }


    // MARK: - GroupQueryViewModelProtocol Methods
    func groupForIndex(_ index: Int) -> GroupDetailViewModelProtocol? {
        return groups[safe: index]
    }

    func fetchGroups() {
        GroupManager.shared.fetchAllGroups(success: { [weak self] (fetchedGroups) in
            guard let strongSelf = self else { return }
            for group in fetchedGroups {
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
}
