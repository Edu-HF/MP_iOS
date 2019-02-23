//
//  APIClient.swift
//  MP
//
//  Created by Lagash on 15/02/2019.
//  Copyright © 2019 ezCode. All rights reserved.
//

import UIKit
import Alamofire

class APIClient: NSObject {
    
    fileprivate var mainSM: SessionManager
    
    override init() {
        mainSM = Alamofire.SessionManager()
    }
    
    func requestGET(urlIn: String, handlerIn: ResponseHandler) {
        
        guard let mainURL = URL(string: MPConstants.MP_MAIN_SERVER_URL.rawValue + urlIn) else { return }
        
        mainSM.request(mainURL, method: .get, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).responseJSON { response in
            
            switch response.result {
            case .success(let value):
                if let sCode = response.response?.statusCode {
                    switch(sCode){
                    case 100, 200, 204, 404:
                        handlerIn.onSuccess(value as AnyObject)
                        //handler.onSuccess(jsonResponse as AnyObject)
                    case 400, 401:
                        handlerIn.onFailed(MPConstants.MP_NETWORK_ERROR_400 as AnyObject)
                    default:
                        handlerIn.onFailed(MPConstants.MP_DEFAULT_NETWORK_ERROR as AnyObject)
                    }
                }
            case .failure(let error):
                print("The Request Of: " + urlIn + " FAIL !!! Reason: " , error)
                handlerIn.onFailed(MPConstants.MP_DEFAULT_NETWORK_ERROR as AnyObject)
            }
        }
    }
}
