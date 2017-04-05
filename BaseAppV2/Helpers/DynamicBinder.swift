//
//  DynamicBinder.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/9/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

/**
    Generic class for binding values and listening
    for value changes. This uses a single listener.
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
     
        - Parameter listener: A `Listener?` representing the
                              closure that gets invoked when
                              the value changes.
    */
    func bind(_ listener: Listener?) {
        self.listener = listener
    }
    
    /**
        Binds the listener for listening for changes
        to the value. It immediately gets fired.
     
        - Parameter listener: A `Listener?` representing the
                              closure that gets invoked when
                              the value changes.
    */
    func bindAndFire(_ listener: Listener?) {
        self.listener = listener
        listener?(value)
    }
}


/**
    Generic class for binding values and listening
    for value changes from multiple locations.
*/
class MultiDynamicBinder<T> {
    
    // MARK: - Typealias
    typealias Listener = (T) -> Void
    
    
    // MARK: - Public Instance Attributes
    var listeners: [Listener?]
    var observers: [Any]
    var value: T {
        didSet {
            listeners.forEach({ $0?(value) })
        }
    }
    
    
    // MARK: - Initializers
    
    /**
        Initializes an instance of `MultiDynamicBinder`.
     
        - Parameter value: A `T` representing the value to
                           bind and listen for changes.
    */
    init(_ value: T) {
        self.value = value
        listeners = [Listener?]()
        observers = [Any]()
    }
    
    
    // MARK: - Public Instance Methods
    
    /**
        Binds the listener for listening for changes
        to the value.
     
        - Parameters:
            - listener: A `Listener?` representing the
                        closure that gets invoked when
                        the value changes.
            - observer: An `Any` representing the object
                        that registered the listener.
    */
    func bind(_ listener: Listener?, for observer: Any) {
        listeners.append(listener)
        observers.append(observer)
    }
    
    /**
        Binds the listener for listening for changes
        to the value. It immediately gets fired.
     
        - Parameters:
            - listener: A `Listener?` representing the
                        closure that gets invoked when
                        the value changes.
            - observer: An `Any` representing the object
                        that registered the listener.
    */
    func bindAndFire(_ listener: Listener?, for observer: Any) {
        listeners.append(listener)
        observers.append(observer)
        listener?(value)
    }
    
    /**
        Removes the listener the observer registered.
     
        - Parameter observer: An `Any` representing the object
                              that has a listener registered.
    */
    func removeListener(for observer: Any) {
        guard let index = observers.index(where: { (object: Any) -> Bool in
            guard let object1 = object as? NSObject,
                  let object2 = observer as? NSObject else { return false }
            return object1 === object2
        }) else { return }
        _ = observers.remove(at: index)
        _ = listeners.remove(at: index)
    }
}
