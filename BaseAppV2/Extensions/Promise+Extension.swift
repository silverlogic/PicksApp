//
//  Promise+Extension.swift
//  BaseAppV2
//
//  Created by Manuel García-Estañ on 11/3/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation
import PromiseKit

extension Promise {
    
    /**
        The provided closure executes when this promise rejects. It automatically casts
        the error object to type `APIError`. If the type is different then an error object
        of type `Error` will be used instead.
     
        - Parameters:
            - on: The queue to which the provided closure dispatches.
            - policy: The default policy does not execute your handler for cancellation errors.
            - execute: The handler to execute if this promise is rejected.
    */
    func catchAPIError(on q: DispatchQueue = .default, policy: CatchPolicy = .allErrorsExceptCancellation, execute body: @escaping (BaseError) -> Void) {
        self.catch(on: DispatchQueue.main, policy: .allErrors, execute: { (error: Error) in
                guard let error = error as? BaseError else {
                    body(BaseError.generic)
                    return
                }
                body(error)
            })
    }
}
