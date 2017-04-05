//
//  ChangeEmailVerifyViewModel.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 4/4/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A protocol for defining state and behavior
    for change email verify.
*/
protocol ChangeEmailVerifyViewModelProtocol {
    
    // MARK: - Instance Attributes
    var changeEmailVerifyError: DynamicBinder<BaseError?> { get }
    var changeEmailVerifySuccess: DynamicBinder<Bool> { get }
    
    
    // MARK: - Instance Methods
    func changeEmailVerify()
    func cancelChangeEmail()
}


/**
    A class that conforms to `ChangeEmailVerifyViewModelProtocol`
    and implements it.
*/
final class ChangeEmailVerifyViewModel: ChangeEmailVerifyViewModelProtocol {
    
    // MARK: - ChangeEmailVerifyViewModelProtocol Attributes
    var changeEmailVerifyError: DynamicBinder<BaseError?>
    var changeEmailVerifySuccess: DynamicBinder<Bool>
    
    
    // MARK: - Private Instance Attributes
    fileprivate let token: String
    fileprivate let userId: Int
    
    
    // MARK: - Initializers
    
    /**
        Initializes an instance of `ChangeEmailVerifyViewModel`.
     
        - Parameters:
            - token: A `String` representing the
                     token received from change email
                     confirm deep link.
            - userId: A `Int` representing the user
                      that changed their email from
                      change email confirm deep link.
    */
    init(token: String, userId: Int) {
        changeEmailVerifyError = DynamicBinder(nil)
        changeEmailVerifySuccess = DynamicBinder(false)
        self.token = token
        self.userId = userId
    }
    
    
    // MARK: - ChangeEmailVerifyViewModelProtocol Methods
    func changeEmailVerify() {
        AuthenticationManager.shared.changeEmailVerify(token: token, userId: userId, success: { [weak self] in
            guard let strongSelf = self else { return }
            if SessionManager.shared.authorizationToken == nil {
                strongSelf.changeEmailVerifySuccess.value = true
                NotificationCenter.default.post(name: .UserLoggedOut, object: nil)
                return
            }
            AuthenticationManager.shared.currentUser(success: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.changeEmailVerifySuccess.value = true
                NotificationCenter.default.post(name: .UserLoggedIn, object: nil)
            }, failure: { [weak self] (error: BaseError) in
                guard let strongSelf = self else { return }
                strongSelf.changeEmailVerifyError.value = error
            })
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            strongSelf.changeEmailVerifyError.value = error
        }
    }
    
    func cancelChangeEmail() {
        guard let _ = SessionManager.shared.authorizationToken else {
            NotificationCenter.default.post(name: .UserLoggedOut, object: nil)
            return
        }
        NotificationCenter.default.post(name: .UserLoggedIn, object: nil)
    }
}
