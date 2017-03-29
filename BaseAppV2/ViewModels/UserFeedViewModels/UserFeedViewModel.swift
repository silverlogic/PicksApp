//
//  UserFeedViewModel.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/30/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A protocol for defining state and behavior
    for displaying users in a feed.
*/
protocol UserFeedViewModelProtocol {
    
    // MARK: - Instance Attributes
    var numberOfUsers: DynamicBinder<Int> { get }
    var insertionPositions: DynamicBinder<[IndexPath]?> { get }
    var fetchUsersError: DynamicBinder<BaseError?> { get }
    var endOfUsers: DynamicBinder<Bool> { get }
    
    
    // MARK: - Instance Methods
    func fetchUsers(clean: Bool)
    func userWithIndex(_ index: Int) -> User?
}


/**
    A class that conforms to `UserFeedViewModelProtocol`
    and implements it.
*/
final class UserFeedViewModel: UserFeedViewModelProtocol {
    
    // MARK: - UserFeedViewModelProtocol Attributes
    var numberOfUsers: DynamicBinder<Int>
    var insertionPositions: DynamicBinder<[IndexPath]?>
    var fetchUsersError: DynamicBinder<BaseError?>
    var endOfUsers: DynamicBinder<Bool>
    
    
    // MARK: - Private Instance Attributes
    private var users: [User]
    private var userPaginator: UserPaginator
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `UserFeedViewModel`.
    init() {
        numberOfUsers = DynamicBinder(0)
        insertionPositions = DynamicBinder(nil)
        fetchUsersError = DynamicBinder(nil)
        endOfUsers = DynamicBinder(false)
        users = [User]()
        userPaginator = UserPaginator()
    }
    
    
    // MARK: - UserFeedViewModelProtocol Methods
    func fetchUsers(clean: Bool) {
        userPaginator.fetchUsers(clean: clean, success: { [weak self] (fetchedUsers: [User]) in
            guard let strongSelf = self else { return }
            var indexPaths: [IndexPath]?
            if strongSelf.users.count == 0 {
                strongSelf.users.append(contentsOf: fetchedUsers)
                strongSelf.numberOfUsers.value = strongSelf.users.count
            } else {
                strongSelf.users.append(contentsOf: fetchedUsers)
                strongSelf.numberOfUsers.value = strongSelf.users.count
                let insertionPositions = strongSelf.users.count - fetchedUsers.count
                indexPaths = [IndexPath]()
                for index in insertionPositions..<strongSelf.users.count {
                    indexPaths?.append(IndexPath(item: index, section: 0))
                }
            }
            strongSelf.insertionPositions.value = indexPaths
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            if error.statusCode == 108 {
                strongSelf.endOfUsers.value = true
            } else if error.statusCode == 109 {
                return
            } else {
                strongSelf.fetchUsersError.value = error
            }
        }
    }
    
    func userWithIndex(_ index: Int) -> User? {
        return users[safe: index]
    }
}
