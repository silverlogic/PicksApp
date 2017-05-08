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
protocol UserFeedViewModelProtocol: class {
    
    // MARK: - Instance Attributes
    var numberOfUsers: DynamicBinderInterface<Int> { get }
    var insertionPositions: DynamicBinderInterface<[IndexPath]?> { get }
    var fetchUsersError: DynamicBinderInterface<BaseError?> { get }
    var endOfUsers: DynamicBinderInterface<Bool> { get }
    
    
    // MARK: - Instance Methods
    func fetchUsers(clean: Bool)
    func userWithIndex(_ index: Int) -> User?
}


/**
    A `ViewModelsManager` class extension for `UserFeedViewModelProtocol`.
 */
extension ViewModelsManager {
    
    /**
        Returns an instance conforming to `UserFeedViewModelProtocol`.
     
        - Return: an instance conforming to `UserFeedViewModelProtocol`.
     */
    class func userFeedViewModel() -> UserFeedViewModelProtocol {
        return UserFeedViewModel()
    }
}


/**
    A class that conforms to `UserFeedViewModelProtocol`
    and implements it.
*/
fileprivate final class UserFeedViewModel: UserFeedViewModelProtocol {
    
    // MARK: - UserFeedViewModelProtocol Attributes
    var numberOfUsers: DynamicBinderInterface<Int> {
        return numberOfUsersBinder.interface
    }
    var insertionPositions: DynamicBinderInterface<[IndexPath]?> {
        return insertionPositionsBinder.interface
    }
    var fetchUsersError: DynamicBinderInterface<BaseError?> {
        return fetchUsersErrorBinder.interface
    }
    var endOfUsers: DynamicBinderInterface<Bool> {
        return endOfUsersBinder.interface
    }
    
    
    // MARK: - Private Instance Attributes
    private var users: [User]
    private var userPaginator: UserPaginator
    private var numberOfUsersBinder: DynamicBinder<Int>
    private var insertionPositionsBinder: DynamicBinder<[IndexPath]?>
    private var fetchUsersErrorBinder: DynamicBinder<BaseError?>
    private var endOfUsersBinder: DynamicBinder<Bool>
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `UserFeedViewModel`.
    init() {
        numberOfUsersBinder = DynamicBinder(0)
        insertionPositionsBinder = DynamicBinder(nil)
        fetchUsersErrorBinder = DynamicBinder(nil)
        endOfUsersBinder = DynamicBinder(false)
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
                strongSelf.numberOfUsersBinder.value = strongSelf.users.count
            } else {
                strongSelf.users.append(contentsOf: fetchedUsers)
                strongSelf.numberOfUsersBinder.value = strongSelf.users.count
                let insertionPositions = strongSelf.users.count - fetchedUsers.count
                indexPaths = [IndexPath]()
                for index in insertionPositions..<strongSelf.users.count {
                    indexPaths?.append(IndexPath(item: index, section: 0))
                }
            }
            strongSelf.insertionPositionsBinder.value = indexPaths
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            if error.statusCode == 108 {
                strongSelf.endOfUsersBinder.value = true
            } else if error.statusCode == 109 {
                return
            } else {
                strongSelf.fetchUsersErrorBinder.value = error
            }
        }
    }
    
    func userWithIndex(_ index: Int) -> User? {
        return users[safe: index]
    }
}
