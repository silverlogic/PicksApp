//
//  APIError.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 3/6/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

/**
    A class entity representing an error that
    the API would return.
*/
final class APIError: Error {
    
    // MARK: - Attributes
    let statusCode: Int
    let errorDescription: String
    
    
    // MARK: - Initializers
    
    /**
        Initializes an instance of `APIError` with
        a given status code and an error description.
     
        - Parameters:
            - statusCode: An `Int` representing the status
                          code of the response. The status
                          code would usually be within the
                          four hundred to five hundred.
            - errorDescription: A `String` representing the
                                description of the error given
                                from the API.
    */
    init(statusCode: Int, errorDescription: String) {
        self.statusCode = statusCode
        self.errorDescription = errorDescription
    }
}


// MARK: - Public Class Methods
extension APIError {
    
    /**
        Takes an error dictionary returned from the
        API and gets the error description.
     
        - Parameters errorDictionary: An `[String: Any]` representing
                                      the error dictionary returned from
                                      the API.
        
        - Returns: A `String` representing the error description. If the
                   dictionary can't be parsed, a default error description
                   will be returned.
    */
    class func errorDescriptionFromErrorDictionary(_ errorDictionary: [String: Any]) -> String {
        // @TODO: Use if lets for parsing for possible keys
        return NSLocalizedString("APIError.DefaultErrorDescription", comment: "Default Error")
    }
}
