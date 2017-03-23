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
    and fetching objects from the Core Data stack.
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
    
    /**
        Generic method for fetching objects from the current
        object space.
        
        - Note: When calling this method, it can be called on
                the main thread since it internally will go on
                a background thread for fetching.
     
        - Parameters:
            - predicate: A `NSPredicate` that indicates
                         how objects should be filtered.
                         `nil` can be passed if no filtering
                         is necessary.
            - sortDescriptors: An `[NSSortDescriptor]` indicate how
                               the objects returned should be sorted
                               by. `nil` can be passed if the objects
                               do not need to be sorted.
            - entityType: A `T.Type` indicating the entity type.
            - success: A closure that gets invoked when retreiving the objects
                       was successful. Passes an `[T]` representing
                       the results of the fetch.
            - failure: A closure that gets invoked when retreving the objects failed.
    */
    func fetchObjects<T: NSManagedObject>(predicate: NSPredicate?,
                                          sortDescriptors: [NSSortDescriptor]?,
                                          entityType: T.Type,
                                          success: @escaping (_ objects: [T]) -> Void,
                                          failure: @escaping () -> Void) {
        let objectFetchRequest: NSFetchRequest<NSFetchRequestResult>
        if #available(iOS 10.0, *) {
            objectFetchRequest = T.fetchRequest()
        } else {
            objectFetchRequest = NSFetchRequest(entityName: T.entityName)
        }
        if let queryPredicate = predicate {
            objectFetchRequest.predicate = queryPredicate
        }
        if let descriptors = sortDescriptors {
            objectFetchRequest.sortDescriptors = descriptors
        }
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: objectFetchRequest as! NSFetchRequest<T>) { (result: NSAsynchronousFetchResult<T>) in
            guard let objects = result.finalResult else {
                failure()
                return
            }
            success(objects)
        }
        do {
            try _managedObjectContext.execute(asyncFetchRequest)
        } catch {
            AppLogger.shared.logMessage(error.localizedDescription, for: .error)
            failure()
        }
    }
    
    /**
        Generic method for deleting an object from the current
        object space.
     
        - Note: When calling this method, it can be called on
                then main thread since it internally will go on
                a background thread for deleting the object.
     
        - Parameters: 
            - object: A `T` indicating the entity to delete.
            - success: A closure that gets invoked when deleting
                       was successful.
            - failure: A closure that gets invoked when deleting
                       failed. The object space doesn't change if
                       deleting failed.
    */
    func deleteObject<T: NSManagedObject>(_ object: T, success: @escaping () -> Void, failure: @escaping () -> Void) {
        _managedObjectContext.perform { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf._managedObjectContext.delete(object)
            do {
                if strongSelf._managedObjectContext.hasChanges {
                    try strongSelf._managedObjectContext.save()
                    DispatchQueue.main.async {
                        success()
                    }
                }
            } catch {
                AppLogger.shared.logMessage(error.localizedDescription, for: .error)
                DispatchQueue.main.async {
                    failure()
                }
            }
        }
    }
}


// MARK: - Private Instance Methods
fileprivate extension CoreDataStack {
    
    /**
        Initializes the Core Data Stack.
     
        - Warning: If an error occurs during the setup process,
                   a `fatalError` gets thrown with a description
                   of what caused the error.
    */
    fileprivate func initializeCoreDataStack() {
        guard let modelUrl = Bundle.main.url(forResource: CoreDataStackConstants.model, withExtension: CoreDataStackConstants.modelType),
              let managedObjectModel = NSManagedObjectModel(contentsOf: modelUrl) else {
            AppLogger.shared.logMessage("Error Loading Model From Main Bundle!", for: .error)
            fatalError("Error Loading Model From Main Bundle!")
        }
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        _managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        // Check if running in unit test target
        if ProcessInfo.isRunningUnitTests || ProcessInfo.isRunningUITests {
            do {
                try persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
            } catch {
                fatalError("Error Setting Up Stack For Unit Tests!")
            }
            self._managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        } else {
            let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            guard let documentUrl = urls.last else {
                AppLogger.shared.logMessage("Error Getting Document Directory Url!", for: .error)
                fatalError("Error Getting Document Directory Url!")
            }
            let coreDataStoreUrl = documentUrl.appendingPathComponent(CoreDataStackConstants.sqLite)
            let migrationOptions = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
            do {
                try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: coreDataStoreUrl, options: migrationOptions)
            } catch {
                AppLogger.shared.logMessage("Error Performing Core Data Store Migration!", for: .error)
                fatalError("Error Performing Core Data Store Migration!")
            }
            _managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        }
    }
}
