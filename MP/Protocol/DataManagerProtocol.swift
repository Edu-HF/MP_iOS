//
//  DataManagerProtocol.swift
//  MP
//
//  Created by Lagash on 15/02/2019.
//  Copyright © 2019 ezCode. All rights reserved.
//

import UIKit

protocol DataManagerProtocol {

    func getProductsData(handlerIn: ResponseHandler)
    func getCategoriesData(handlerIn: ResponseHandler)
    func getPromotionsData(handlerIn: ResponseHandler)
}
