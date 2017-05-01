//
//  ProfileViewModel.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/23/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A protocol for defining state and behavior
    for the user's profile.
*/
protocol ProfileViewModelProtocol: class {
    
    // MARK: - Instance Attributes
    var fullName: DynamicBinderInterface<String> { get }
    var email: DynamicBinderInterface<String> { get }
    var avatar: DynamicBinderInterface<URL?> { get }
    var updateProfileError: DynamicBinderInterface<BaseError?> { get }
    var updateProfileSuccess: DynamicBinderInterface<Bool> { get }
    var firstName: String { get set }
    var lastName: String { get set }
    var profileImage: UIImage? { get set }
    
    
    // MARK: - Initializers
    init(user: MultiDynamicBinder<User?>)
    
    
    // MARK: - Instance Methods
    func updateProfile()
}


/**
    A `ViewModelsManager` class extension for `ProfileViewModelProtocol`.
 */
extension ViewModelsManager {
    
    /**
        Returns an instance conforming to `ProfileViewModelProtocol`.
     
        - Parameter user: A `MultiDynamicBinder<User?>` representing the
                          multi dynamic binder containing `current user` value.
     
        - Return: an instance conforming to `ProfileViewModelProtocol`.
     */
    class func profileViewModel(user: MultiDynamicBinder<User?>) -> ProfileViewModelProtocol {
        return ProfileViewModel(user: user)
    }
}


/**
    A class that conforms to `ProfileViewModelProtocol`
    and implements it.
*/
fileprivate final class ProfileViewModel: ProfileViewModelProtocol {
    
    // MARK: - Private Instance Attributes
    fileprivate var user: MultiDynamicBinder<User?>
    fileprivate var fullNameBinder: DynamicBinder<String>
    fileprivate var emailBinder: DynamicBinder<String>
    fileprivate var avatarBinder: DynamicBinder<URL?>
    fileprivate var updateProfileErrorBinder: DynamicBinder<BaseError?>
    fileprivate var updateProfileSuccessBinder: DynamicBinder<Bool>
    
    
    // MARK: - ProfileViewModelProtocol Attributes
    var fullName: DynamicBinderInterface<String> {
        return fullNameBinder.interface
    }
    var email: DynamicBinderInterface<String> {
        return emailBinder.interface
    }
    var avatar: DynamicBinderInterface<URL?> {
        return avatarBinder.interface
    }
    var updateProfileError: DynamicBinderInterface<BaseError?> {
        return updateProfileErrorBinder.interface
    }
    var updateProfileSuccess: DynamicBinderInterface<Bool> {
        return updateProfileSuccessBinder.interface
    }
    var firstName: String
    var lastName: String
    var profileImage: UIImage?
    
    
    // MARK: - ProfileViewModelProtocol Initializers
    init(user: MultiDynamicBinder<User?>) {
        self.user = user
        if let name = self.user.value?.fullName {
            fullNameBinder = DynamicBinder(name)
        } else {
            fullNameBinder = DynamicBinder("")
        }
        if let userEmail = self.user.value?.email {
            emailBinder = DynamicBinder(userEmail)
        } else {
            emailBinder = DynamicBinder("")
        }
        if let userAvatar = self.user.value?.avatarUrl {
            avatarBinder = DynamicBinder(userAvatar)
        } else {
            avatarBinder = DynamicBinder(nil)
        }
        updateProfileErrorBinder = DynamicBinder(nil)
        updateProfileSuccessBinder = DynamicBinder(false)
        if let userFirstName = self.user.value?.firstName {
            firstName = userFirstName
        } else {
            firstName = ""
        }
        if let userLastName = self.user.value?.lastName {
            lastName = userLastName
        } else {
            lastName = ""
        }
        profileImage = nil
        user.interface.bind({ [weak self] (user: User?) in
            guard let strongSelf = self,
                  let newUser = user else { return }
            strongSelf.fullNameBinder.value = newUser.fullName
            if let userEmail = newUser.email {
                strongSelf.emailBinder.value = userEmail
            } else {
                strongSelf.emailBinder.value = ""
            }
            if let userAvatar = newUser.avatarUrl {
                strongSelf.avatarBinder.value = userAvatar
            } else {
                strongSelf.avatarBinder.value = nil
            }
            if let userFirstName = newUser.firstName {
                strongSelf.firstName = userFirstName
            } else {
                strongSelf.firstName = ""
            }
            if let userLastName = newUser.lastName {
                strongSelf.lastName = userLastName
            } else {
                strongSelf.lastName = ""
            }
            strongSelf.profileImage = nil
        }, for: self)
    }
    
    
    // MARK: - Deinitializers
    
    /// Deinitializes an instance of `ProfileViewModel`.
    deinit {
        user.interface.unbind(for: self)
    }
    
    
    // MARK: - ProfileViewModelProtocol Methods
    func updateProfile() {
        if firstName.isEmpty || lastName.isEmpty {
            updateProfileErrorBinder.value = BaseError.fieldsEmpty
            if let userFirstName = user.value?.firstName {
                firstName = userFirstName
            }
            if let userLastName = user.value?.lastName {
                lastName = userLastName
            }
            return
        }
        let baseString: String?
        if let image = profileImage {
            guard let imageData = UIImageJPEGRepresentation(image, 0.7) else {
                updateProfileErrorBinder.value = BaseError.generic
                return
            }
            baseString = imageData.base64EncodedString(options: .lineLength64Characters)
        } else {
            baseString = nil
        }
        let updateInfo = UpdateInfo(referralCodeOfReferrer: nil, avatarBaseString: baseString, firstName: firstName, lastName: lastName)
        SessionManager.shared.update(updateInfo, success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.updateProfileSuccessBinder.value = true
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            strongSelf.updateProfileErrorBinder.value = error
        }
    }
}
