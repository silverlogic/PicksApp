//
//  UserPaginator.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/30/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A paginator responsible for getting
    a paginated list of users that are
    registered.
*/
final class UserPaginator {
    
    // MARK: - Private Instance Attributes
    private var nextPagination: Pagination? = nil
    private var isLoading = false
    
    
    // MARK: Public Instance Methods
    
    /**
        Gets a paginated list of users.
     
        - Parameters:
            - clean: A `Bool` determining if the object space
                     that contains instances of `User` should be
                     removed except for ones received from the API.
            - success: A closure that gets invoked
                       when getting the paginated list
                       of users was successful. Passes
                       an `[User]` object.
            - failure: A closure that gets invoked
                       when getting the paginated list
                       of users failed. Passes a `BaseError`
                       object containing the error that occured.
    */
    func fetchUsers(clean: Bool, success: @escaping (_ users: [User]) -> Void, failure: @escaping (_ error: BaseError) -> Void) {
        if isLoading {
            failure(BaseError.stillLoadingResults)
            return
        }
        isLoading = true
        if let pagination = nextPagination {
            guard let _ = pagination.next else {
                isLoading = false
                failure(BaseError.endOfPagination)
                return
            }
        }
        let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
        dispatchQueue.async { [weak self] in
            guard let strongSelf = self else { return }
            let networkClient = NetworkClient(baseUrl: ConfigurationManager.shared.apiUrl!, manageObjectContext: CoreDataStack.shared.managedObjectContext)
            networkClient.enqueue(UserEndpoint.users(pagination: strongSelf.nextPagination))
            .then(on: dispatchQueue, execute: { [weak self] (response: PaginatedResponse<User>) -> Void in
                if clean {
                    let predicate: NSPredicate
                    if let userId = SessionManager.shared.currentUser.value?.userId {
                        predicate = NSPredicate(format: "NOT self in %@ && userId != %d", response.results.array, userId)
                    } else {
                        predicate = NSPredicate(format: "NOT self in %@", response.results.array)
                    }
                    let fetchRequest = User.allUsersFetchRequest()
                    fetchRequest.predicate = predicate
                    CoreDataStack.shared.fetchObjects(fetchRequest: fetchRequest, success: { (users: [User]) in
                        let dispatchGroup = DispatchGroup()
                        users.forEach({ (user: User) in
                            dispatchGroup.enter()
                            CoreDataStack.shared.deleteObject(user, success: {
                                dispatchGroup.leave()
                            }, failure: {
                                dispatchGroup.leave()
                            })
                        })
                        dispatchGroup.notify(queue: DispatchQueue.main, execute: { [weak self] in
                            guard let strongSelf = self else { return }
                            strongSelf.nextPagination = response.pagination
                            strongSelf.isLoading = false
                            success(response.results.array)
                        })
                    }, failure: { 
                        failure(BaseError.generic)
                    })
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    guard let strongSelf = self else { return }
                    strongSelf.nextPagination = response.pagination
                    strongSelf.isLoading = false
                    success(response.results.array)
                }
            })
            .catchAPIError(on: DispatchQueue.main, policy: .allErrors, execute: { [weak self] (error: BaseError) in
                guard let strongSelf = self else { return }
                strongSelf.isLoading = false
                failure(error)
            })
        }
    }
}
