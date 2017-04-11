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
    var fullName: DynamicBinder<String> { get }
    var email: DynamicBinder<String> { get }
    var avatar: DynamicBinder<URL?> { get }
    var updateProfileError: DynamicBinder<BaseError?> { get }
    var updateProfileSuccess: DynamicBinder<Bool> { get }
    var firstName: String { get set }
    var lastName: String { get set }
    var profileImage: UIImage? { get set }
    
    
    // MARK: - Initializers
    init(user: MultiDynamicBinder<User?>)
    
    
    // MARK: - Instance Methods
    func updateProfile()
}


/**
    A class that conforms to `ProfileViewModelProtocol`
    and implements it.
*/
final class ProfileViewModel: ProfileViewModelProtocol {
    
    // MARK: - Private Instance Attributes
    fileprivate var user: MultiDynamicBinder<User?>
    
    
    // MARK: - ProfileViewModelProtocol Attributes
    var fullName: DynamicBinder<String>
    var email: DynamicBinder<String>
    var avatar: DynamicBinder<URL?>
    var updateProfileError: DynamicBinder<BaseError?>
    var updateProfileSuccess: DynamicBinder<Bool>
    var firstName: String
    var lastName: String
    var profileImage: UIImage?
    
    
    // MARK: - ProfileViewModelProtocol Initializers
    init(user: MultiDynamicBinder<User?>) {
        self.user = user
        if let name = self.user.value?.fullName {
            fullName = DynamicBinder(name)
        } else {
            fullName = DynamicBinder("")
        }
        if let userEmail = self.user.value?.email {
            email = DynamicBinder(userEmail)
        } else {
            email = DynamicBinder("")
        }
        if let userAvatar = self.user.value?.avatarUrl {
            avatar = DynamicBinder(userAvatar)
        } else {
            avatar = DynamicBinder(nil)
        }
        updateProfileError = DynamicBinder(nil)
        updateProfileSuccess = DynamicBinder(false)
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
        user.bind({ [weak self] (user: User?) in
            guard let strongSelf = self,
                  let newUser = user else { return }
            strongSelf.fullName.value = newUser.fullName
            if let userEmail = newUser.email {
                strongSelf.email.value = userEmail
            } else {
                strongSelf.email.value = ""
            }
            if let userAvatar = newUser.avatarUrl {
                strongSelf.avatar.value = userAvatar
            } else {
                strongSelf.avatar.value = nil
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
        user.removeListeners(for: self)
    }
    
    
    // MARK: - ProfileViewModelProtocol Methods
    func updateProfile() {
        if firstName.isEmpty || lastName.isEmpty {
            updateProfileError.value = BaseError.fieldsEmpty
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
                updateProfileError.value = BaseError.generic
                return
            }
            baseString = imageData.base64EncodedString(options: .lineLength64Characters)
        } else {
            baseString = nil
        }
        let updateInfo = UpdateInfo(referralCodeOfReferrer: nil, avatarBaseString: baseString, firstName: firstName, lastName: lastName)
        SessionManager.shared.update(updateInfo, success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.updateProfileSuccess.value = true
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            strongSelf.updateProfileError.value = error
        }
    }
}
