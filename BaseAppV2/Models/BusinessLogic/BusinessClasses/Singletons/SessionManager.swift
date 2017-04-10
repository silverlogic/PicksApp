//
//  SessionManager.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/8/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A singleton responsible for managing the current user.
*/
final class SessionManager {
    
    // MARK: - Shared Instance
    static let shared = SessionManager()
    
    
    // MARK: - Private Instance Attributes
    fileprivate var _currentUser: MultiDynamicBinder<User?>
    fileprivate var _authorizationToken: String?
    
    
    // MARK: - Initializers
    
    /// Initializes a shared instance of `SessionManager`.
    private init() {
        _currentUser = MultiDynamicBinder(nil)
        // Check if running in Unit Tests
        if ProcessInfo.isRunningUnitTests {
            return
        }
        loadSession()
    }
}


// MARK: - Getters & Setters
extension SessionManager {
    
    /// The current user.
    var currentUser: MultiDynamicBinder<User?> {
        get {
            return _currentUser
        }
        set {
            _currentUser = newValue
            UserDefaults.standard.set(_currentUser.value?.userId, forKey: SessionConstants.userId)
        }
    }
    
    /// The authorization token to use for network requests.
    var authorizationToken: String? {
        get {
            return _authorizationToken
        }
        set {
            _authorizationToken = newValue
            UserDefaults.standard.set(newValue, forKey: SessionConstants.authorizationToken)
        }
    }
}


// MARK: - Public Instance Methods
extension SessionManager {
    
    /**
        Updates the current user.
     
        - Parameters:
            - updateInfo: A `UpdateInfo` representing the information needed
                          for updating the current user.
            - success: A closure that gets invoked when updating the current
                       user was successful.
            - failure: A closure that gets invoked when updating the current
                       user failed. Passes a `BaseError` object that contains
                       the error that occured.
    */
    func update(_ updateInfo: UpdateInfo, success: @escaping () -> Void, failure: @escaping (_ error: BaseError) -> Void) {
        let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
        let userId = _currentUser.value?.userId
        dispatchQueue.async {
            let networdClient = NetworkClient(baseUrl: ConfigurationManager.shared.apiUrl!, manageObjectContext: CoreDataStack.shared.managedObjectContext)
            networdClient.enqueue(AuthenticationEndpoint.update(updateInfo: updateInfo, userId: Int(userId!)))
            .then(on: DispatchQueue.main, execute: { [weak self] (user: User) -> Void in
                guard let strongSelf = self else { return }
                strongSelf._currentUser.value = user
                success()
            })
            .catchAPIError(on: DispatchQueue.main, policy: .allErrors, execute: { (error: BaseError) in
                failure(error)
            })
        }
    }
    
    /**
        Logs out the current user and terminates their
        session.
    */
    func logout() {
        guard let user = _currentUser.value else { return }
        CoreDataStack.shared.deleteObject(user, success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf._currentUser.value = nil
            strongSelf._authorizationToken = nil
            UserDefaults.standard.removeObject(forKey: SessionConstants.authorizationToken)
            UserDefaults.standard.removeObject(forKey: SessionConstants.userId)
            NotificationCenter.default.post(name: .UserLoggedOut, object: nil)
        }, failure: {
            AppLogger.shared.logMessage("Error Logging Out User!", for: .error)
        })
    }
}


// MARK: - Private Instance Methods
fileprivate extension SessionManager {
    
    /**
        Loads the authorization token from `UserDefaults` and then loads
        the current user from local storage if the user is already logged in
        for the current session.
    */
    fileprivate func loadSession() {
        guard let token = UserDefaults.standard.value(forKey: SessionConstants.authorizationToken) as? String,
              let userId = UserDefaults.standard.value(forKey: SessionConstants.userId) as? Int else { return }
        _authorizationToken = token
        let predicate = NSPredicate(format: "userId == %d", userId)
        CoreDataStack.shared.fetchObjects(predicate: predicate, sortDescriptors: nil, entityType: User.self, success: { (users: [User]) in
            if users.count != 1 {
                self.loadUser()
            } else {
                guard let user = users.first else { return }
                self._currentUser.value = user
            }
        }, failure: {
            self.loadUser()
        })
    }
    
    /**
        Loads the current user from the API.
    */
    fileprivate func loadUser() {
        DispatchQueue.global(qos: .userInitiated).async {
            let networkClient = NetworkClient(baseUrl: ConfigurationManager.shared.apiUrl!, manageObjectContext: CoreDataStack.shared.managedObjectContext)
            networkClient.enqueue(AuthenticationEndpoint.currentUser)
            .then(on: DispatchQueue.main, execute: { (user: User) -> Void in
                self._currentUser.value = user
            })
            .catchAPIError(on: DispatchQueue.main, policy: .allErrors, execute: { (error: BaseError) in
            })
        }
    }
}
