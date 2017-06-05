//
//  SeasonManager.swift
//  BaseAppV2
//
//  Created by Michael Sevy on 5/30/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import AlamofireCoreData

/**
    A singleton responsible for the Season class.
 */
final class SeasonManager {

    // MARK: - Shared Instance
    static let shared = SeasonManager()


    /// Initializes a shared instance of `SeasonManager`.
    private init() {}
}


// MARK: - Public Instance Methods
extension SeasonManager {
    /**
     Gets the Scores for a seasonId
        - Parameters: An `Int` respresenting a season of which
                      is associated with a group object
            - success: A closure that gets invoked when the getting the user's
                       score/s and returns an array of scores for that season.
            - failure: A closure that gets invoked when getting the
                       users's score/s fails. Passes a 'BaseError`
                       object containing the error that occured.
     */
    func scoresForSeason(seasonId: Int16, success: @escaping (_ scores: [Score]) -> Void, failure: @escaping (_ error: BaseError) -> Void) {
        let dispatchQueue = DispatchQueue.global(qos: .userInitiated)
        dispatchQueue.async {
            let networkClient = NetworkClient(baseUrl: ConfigurationManager.shared.apiUrl!, manageObjectContext: CoreDataStack.shared.managedObjectContext)
            networkClient.enqueue(SeasonEndpoint.fetchScores(seasonId: seasonId))
            .then(on: DispatchQueue.main, execute: { (scores: Many<Score>) -> Void in
                success(scores.array)
            })
            .catchAPIError(on: DispatchQueue.main, policy: .allErrors, execute: { (error: BaseError) in
                failure(error)
            })
        }
    }
}
