//
//  UserManager.swift
//  BaseAppV2
//
//  Created by Michael Sevy on 6/5/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
 A Singleton responsible for managing the user objects in the app
 */
final class UserManager {

    // MARK: - Shared Instance
    static let shared = UserManager()


    // MARK: - Initializers

    /// Intializes a shared instance of `UserManager`.
    private init() {}
}


// MARK: - Public Instance Methods
extension UserManager {
        /**
            Get the user associated with that users Id, mainly
            used to look up the user who creates a Group

            - Parameters:
                - success: A closure that gets invoked when getting
                           the requested user was successful
                - failure: A closure that get invoked when getting
                           the requested user fails. Passes a `BaseError`
                           object containing that error.
     */
    func retrieveUser(userId: Int, success: @escaping (_ otherUser: User) -> Void, failure: @escaping (_ error: BaseError) -> Void) {
        let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
        dispatchQueue.async {
            let networkClient = NetworkClient(baseUrl: ConfigurationManager.shared.apiUrl!, manageObjectContext: CoreDataStack.shared.managedObjectContext)
            networkClient.enqueue(UserEndpoint.retrieveUser(userId: userId))
            .then(on: DispatchQueue.main, execute: { (user: User) -> Void in
                success(user)
            })
            .catchAPIError(on: DispatchQueue.main, policy: .allErrors, execute: { (error: BaseError) in
                failure(error)
            })
        }
    }
}
