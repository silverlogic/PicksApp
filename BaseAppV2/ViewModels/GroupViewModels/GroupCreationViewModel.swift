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
    
    
    // MARK: - Instance Methods
    func createGroup()
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
    var creationError: DynamicBinderInterface<BaseError?> {
        return creationErrorBinder.interface
    }
    var creationSuccess: DynamicBinderInterface<Bool> {
        return creationSuccessBinder.interface
    }
    
    
    // MARK: - Private Instance Attributes
    private var creationErrorBinder: DynamicBinder<BaseError?>
    private var creationSuccessBinder: DynamicBinder<Bool>
    
    
    // MARK: - Initializers
    
    /// Initializes an instance of `GroupCreationViewModel`.
    init() {
        groupName = ""
        numberOfPeople = 0
        creationErrorBinder = DynamicBinder(nil)
        creationSuccessBinder = DynamicBinder(false)
    }
    
    
    // MARK: - GroupCreationViewModelProtocol Methods
    func createGroup() {
        if groupName == "" || numberOfPeople == 0 {
            creationErrorBinder.value = BaseError.fieldsEmpty
            return
        }
        if groupName.characters.count > 20 {
            creationErrorBinder.value = BaseError.numberOfCharactersExceeded
            return
        }
    }
}
