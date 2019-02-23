//
//  ShoppingCar.swift
//  MP
//
//  Created by Lagash on 15/02/2019.
//  Copyright © 2019 ezCode. All rights reserved.
//

import UIKit
import Gloss

class ShoppingCar: NSObject, NSCoding {

    var totalUN: Int = 0
    var totalCost: Double = 0
    var productData: [Product]
    
    init(totalUNIn: Int, totalCostIn: Double, productDataIn: [Product]? = []) {
       
        totalUN = totalUNIn
        totalCost = totalCostIn
        productData = productDataIn!
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let productDataDic = aDecoder.decodeObject(forKey: "productData") as! [NSDictionary]
        var productData: [Product] = []
        for productDic in productDataDic {
            if let tempProd = Product(json: productDic as! JSON) {
               productData.append(tempProd)
            }
        }
        let totalUN = Int(aDecoder.decodeCInt(forKey: "totalUN"))
        let totalCost = aDecoder.decodeDouble(forKey: "totalCost")
        self.init(totalUNIn: totalUN, totalCostIn: totalCost, productDataIn: productData)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(productData.toJSONArray(), forKey: "productData")
        aCoder.encode(totalUN, forKey: "totalUN")
        aCoder.encode(totalCost, forKey: "totalCost")
    }
}
