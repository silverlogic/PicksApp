//
//  CoreDataStack.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/3/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import CoreData

/**
    A singleton responsible for managing, insertion, deletion,
    and fetching objects of the Core Data stack.
*/
final class CoreDataStack {
    
    // MARK: - Shared Instance
    static let shared = CoreDataStack()
    
    
    // MARK: - Private Instance Attributes
    fileprivate var _managedObjectContext: NSManagedObjectContext!
    
    
    // MARK: - Initializers
    private init() {
        initializeCoreDataStack()
    }
}


// MARK: - Getters & Setters
extension CoreDataStack {
    
    /// The current object space being used.
    var managedObjectContext: NSManagedObjectContext {
        return _managedObjectContext
    }
}


// MARK: - Public Instance Methods
extension CoreDataStack {
    // @TODO: implement methods for querying and fetching
}


// MARK: - Private Instance Methods
extension CoreDataStack {
    
    /**
        Initializes the Core Data Stack.
     
        - Warning: If an error occurs during the setup process,
                   a `fatalError` gets thrown with a description
                   of what caused the error.
    */
    fileprivate func initializeCoreDataStack() {
        guard let modelUrl = Bundle.main.url(forResource: CoreDataStackConstants.model, withExtension: CoreDataStackConstants.modelType),
              let managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl) else {
            // @TODO: Log error with SwiftyBeaver once implemented
            fatalError("Error Loading Model From Main Bundle!")
        }
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        _managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        // Check if running in unit test target
        let environmentDictionary = ProcessInfo.processInfo.environment
        if environmentDictionary["RUNNING_UNIT_TESTS"] == "TRUE" {
            do {
                try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
            } catch {
                fatalError("Error Setting Up Stack For Unit Tests!")
            }
            self._managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        } else {
            DispatchQueue.global(qos: .background).async {
                let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
                guard let documentUrl = urls.last else {
                    // @TODO: Log error with SwiftyBeaver once implemented
                    fatalError("Error Getting Document Directory Url!")
                }
                let coreDataStoreUrl = documentUrl.appendingPathComponent(CoreDataStackConstants.sqLite)
                let migrationOptions = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
                do {
                    try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: coreDataStoreUrl, options: migrationOptions)
                } catch {
                    // @TODO: Log error with SwiftyBeaver once implemented
                    fatalError("Error Performing Core Data Store Migration!")
                }
                self._managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
            }
        }
    }
}
