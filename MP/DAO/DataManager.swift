//
//  DataManager.swift
//  MP
//
//  Created by Lagash on 15/02/2019.
//  Copyright © 2019 ezCode. All rights reserved.
//

import UIKit

class DataManager: NSObject, DataManagerProtocol {
    
    static let sharedInstance: DataManagerProtocol = DataManager()
    fileprivate var clientAPI: APIClient
    
    override init() {
        clientAPI = APIClient()
    }
    
    func getProductsData(handlerIn: ResponseHandler) {
        clientAPI.requestGET(urlIn: MPConstants.MP_PRODUCTS_URL.rawValue, handlerIn: handlerIn)
    }
    
    func getCategoriesData(handlerIn: ResponseHandler) {
        clientAPI.requestGET(urlIn: MPConstants.MP_CATEGORIES_URL.rawValue, handlerIn: handlerIn)
    }
    
    func getPromotionsData(handlerIn: ResponseHandler) {
        clientAPI.requestGET(urlIn: MPConstants.MP_PROMOTIONS_URL.rawValue, handlerIn: handlerIn)
    }
}
