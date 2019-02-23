//
//  ResponseHandler.swift
//  MP
//
//  Created by Lagash on 15/02/2019.
//  Copyright © 2019 ezCode. All rights reserved.
//

import UIKit

class ResponseHandler: NSObject {

    let onSuccess: (AnyObject) -> Void
    let onFailed: (AnyObject) -> Void
    
    init(onSuccess: @escaping (AnyObject) -> Void,
         onFailed: @escaping (AnyObject) -> Void) {
        self.onSuccess = onSuccess
        self.onFailed = onFailed
    }
    
    convenience init(onSuccess: @escaping (AnyObject) -> Void,
                     output: MPPresenterProtocol) {
        self.init(onSuccess: onSuccess, onFailed: { error in output.onFailed(errorIn: error) })
    }
}
