//
//  GroupCreationViewModel.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 5/10/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A protocol for defining state and behavior
    for creating a group.
*/
protocol GroupCreationViewModelProtocol {
    
    // MARK: - Instance Attributes
    var groupName: String { get set }
    var numberOfPeople: Int { get set }
    var creationError: DynamicBinderInterface<BaseError?> { get }
    var creationSuccess: DynamicBinderInterface<Bool> { get }
    var joinError: DynamicBinderInterface<BaseError?> { get }
    var joinSuccess: DynamicBinderInterface<Bool> { get }


    // MARK: - Instance Methods
    func createGroup(name: String)
}


/**
    A `ViewModelManager` class extension for `GroupCreationViewModelProtocol`.
*/
extension ViewModelsManager {
    
    /**
        Allocates and returns a instance of `GroupCreationViewModelProtocol`.
     
        - Returns: An instance conforming to `GroupCreationViewModelProtocol`.
    */
    class func groupCreationViewModel() -> GroupCreationViewModelProtocol {
        return GroupCreationViewModel()
    }
}

/**
    A class that conforms to `GroupCreationViewModelProtocol`
    and implements it.
*/
fileprivate final class GroupCreationViewModel: GroupCreationViewModelProtocol {
    
    // MARK: - GroupCreationViewModelProtocol Attributes
    var groupName: String
    var numberOfPeople: Int
    var isPrivate: Bool
    var creationError: DynamicBinderInterface<BaseError?> {
        return creationErrorBinder.interface
    }
    var creationSuccess: DynamicBinderInterface<Bool> {
        return creationSuccessBinder.interface
    }
    var joinError: DynamicBinderInterface<BaseError?> {
        return joinErrorBinder.interface
    }
    var joinSuccess: DynamicBinderInterface<Bool> {
        return joinSuccessBinder.interface
    }
    
    // MARK: - Private Instance Attributes
    private var creationErrorBinder: DynamicBinder<BaseError?>
    private var creationSuccessBinder: DynamicBinder<Bool>
    private var joinErrorBinder: DynamicBinder<BaseError?>
    private var joinSuccessBinder: DynamicBinder<Bool>


    /// Initializes an instance of `GroupCreationViewModel`.
    init() {
        groupName = ""
        numberOfPeople = 0
        isPrivate = false
        creationErrorBinder = DynamicBinder(nil)
        creationSuccessBinder = DynamicBinder(false)
        joinErrorBinder = DynamicBinder(nil)
        joinSuccessBinder = DynamicBinder(false)
    }
    
    
    // MARK: - GroupCreationViewModelProtocol Methods
    func createGroup(name: String) {
        if name == "" {
            creationErrorBinder.value = BaseError.fieldsEmpty
            return
        }
        if name.characters.count > 20 {
            creationErrorBinder.value = BaseError.numberOfCharactersExceeded
            return
        }
        GroupManager.shared.postGroup(groupName: name, success: { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.creationSuccessBinder.value = true
        }) { [weak self] (error: BaseError) in
            guard let strongSelf = self else { return }
            strongSelf.creationErrorBinder.value = error
        }
    }
}
