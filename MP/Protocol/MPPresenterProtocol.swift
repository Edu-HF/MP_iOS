//
//  MPPresenterInteractor.swift
//  MP
//
//  Created by Lagash on 15/02/2019.
//  Copyright © 2019 ezCode. All rights reserved.
//

import UIKit

protocol MPPresenterProtocol {
    
    func getProductData()
    func getCategoriesData()
    func getPromotionsData()
    
    func makeProductFilter(catIDIn: Int)
    func addProductToCar(productIn: Product)
    func removeProductToCar(productIn: Product)
    func getTotalItemsCar() -> String
    func onFailed(errorIn: Any)
}
