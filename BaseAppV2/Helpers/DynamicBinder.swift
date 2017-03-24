//
//  DynamicBinder.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/9/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

/**
    Generic class for binding values and listening
    for value changes.
*/
class DynamicBinder<T> {
    
    // MARK: - Typealias
    typealias Listener = (T) -> Void
    
    
    // MARK: - Public Instance Attributes
    var listener: Listener?
    var value: T {
        didSet {
            listener?(value)
        }
    }
    
    
    // MARK: - Initializers
    
    /**
        Initializes an instance of `DynamicBinder`.
     
        Parameter value: A `T` representing the value to
                         bind and listen for changes.
    */
    init(_ value: T) {
        self.value = value
    }
    
    
    // MARK: - Public Instance Methods
    
    /**
        Binds the listener for listening for changes
        to the value.
     
        - Parameter listener: A `Listener` representing the
                              closure that gets invoked when
                              the value changes.
    */
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    /**
        Binds the listener for listening for changes
        to the value. It immediately gets fired.
     
        - Parameter listener: A `Listener` representing the
                              closure that gets invoked when
                              the value changes.
    */
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}
