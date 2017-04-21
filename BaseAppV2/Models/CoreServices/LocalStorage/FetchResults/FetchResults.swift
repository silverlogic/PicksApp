//
//  FetchResults.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 4/20/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import CoreData

/**
    A protocol for defining state and behavior
    for fetching objects.
*/
protocol FetchResultsProtocol: class {
    
    // MARK: - Instance Attributes
    var itemInserted: DynamicBinder<IndexPath?> { get }
    var itemDeleted: DynamicBinder<IndexPath?> { get }
    var itemUpdated: DynamicBinder<IndexPath?> { get }
    var resultsBeganUpdate: DynamicBinder<Void> { get }
    var resultsFinishedUpdate: DynamicBinder<Void> { get }
    var fetchError: DynamicBinder<BaseError?> { get }
}


/**
    A generic class designed for fetching objects
    for a `UITableView`. This would be used in a view model. 
    It encapsulates all the functionality of working with a 
    `NSFetchResultsController`.
*/
final class FetchResults: NSObject, FetchResultsProtocol {
    
    // MARK: - FetchResultsProtocol Attributes
    var itemInserted: DynamicBinder<IndexPath?>
    var itemDeleted: DynamicBinder<IndexPath?>
    var itemUpdated: DynamicBinder<IndexPath?>
    var resultsBeganUpdate: DynamicBinder<Void>
    var resultsFinishedUpdate: DynamicBinder<Void>
    var fetchError: DynamicBinder<BaseError?>
    
    
    // MARK: - Private Instance Attributes
    fileprivate let fetchResultsController: NSFetchedResultsController<NSFetchRequestResult>
    
    
    // MARK: - Initializers
    
    /**
        Initializes an instance of `FetchResults`.
     
        - Warning: If `fetchRequest` does not have any sort
                   descriptors, the initializer will fail.
     
        - Parameters: 
            - fetchRequest: A `NSFetchRequest<NSFetchRequestResult>` representing the type
                            to fetch for. The fetch request must have at least one sort descriptor.
            - sectionNameKeyPath: A `String` representing the a key path
                                  that returns the section name. Pass `nil` 
                                  to indicate that a single section should be
                                  generated.
            - cacheName: A `String` representing the name of the cache file the 
                         receiver should use. Pass `nil` to prevent caching.
    */
    init?(with fetchRequest: NSFetchRequest<NSFetchRequestResult>, sectionNameKeyPath: String?, cacheName: String?) {
        guard let sortDescriptors = fetchRequest.sortDescriptors, sortDescriptors.count >= 1 else { return nil }
        itemInserted = DynamicBinder(nil)
        itemDeleted = DynamicBinder(nil)
        itemUpdated = DynamicBinder(nil)
        resultsBeganUpdate = DynamicBinder()
        resultsFinishedUpdate = DynamicBinder()
        fetchError = DynamicBinder(nil)
        fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        fetchResultsController.delegate = self
    }
}


// MARK: - NSFetchedResultsControllerDelegate
extension FetchResults: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        resultsBeganUpdate.value = ()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        resultsFinishedUpdate.value = ()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let path = newIndexPath else { return }
            itemInserted.value = path
            break
        case .delete:
            guard let path = indexPath else { return }
            itemDeleted.value = path
            break
        case .move:
            if let path = indexPath {
                itemDeleted.value = path
            }
            if let path = newIndexPath {
                itemInserted.value = path
            }
            break
        case .update:
            guard let path = indexPath else { return }
            itemUpdated.value = path
            break
        }
    }
}


// MARK: - Public Instance Methods
extension FetchResults {
    
    /**
        Begins fetching the objects.
     
        - Note: If an error occurs, it will be
                logged to the console.
    */
    func beginFetchingObjects() {
        do {
            try fetchResultsController.performFetch()
        } catch {
            AppLogger.shared.logMessage(error.localizedDescription, for: .error)
            fetchError.value = BaseError.fetchResultsError
        }
    }
    
    /**
        Gets the total amount of objects fetched.
     
        - Returns: An `Int` representing the total
                   amount of objects. If there aren't
                   objects at all, zero would be returned.
    */
    func numberOfObjects() -> Int {
        guard let fetchedObjects = fetchResultsController.fetchedObjects else { return 0 }
        return fetchedObjects.count
    }
    
    /**
        Gets the number of sections that the fetch results controller
        contains.
     
        - Returns: An `Int` representing the total number of sections. If
                   there aren't any, zero would be returned.
    */
    func numberOfSections() -> Int {
        guard let sections = fetchResultsController.sections else { return 0 }
        return sections.count
    }
    
    /**
        Gets the number of rows in a section of the fetch results controller.
     
        - Parameter sectionIndex: An `Int` representing the section.
     
        - Returns: An `Int` representing the total number of rows. If there aren't
                   any sections, zero will be returned.
    */
    func numberOfRowsForSection(_ sectionIndex: Int) -> Int {
        guard let sections = fetchResultsController.sections,
              let section = sections[safe: sectionIndex] else { return 0 }
        return section.numberOfObjects
    }
    
    /**
        Gets an item from the fetch results controller.
     
        - Parameter indexPath: An `IndexPath` representing the
                               location of the item.
        
        - Returns: A `T` representing the retrieved object. `nil` could
                   be returned if an error occured.
    */
    func itemAtIndexPath<T: NSManagedObject>(_ indexPath: IndexPath) -> T? {
        guard let object = fetchResultsController.object(at: indexPath) as? T else { return nil }
        return object
    }
}
