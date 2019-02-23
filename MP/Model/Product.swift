//
//  Product.swift
//  MP
//
//  Created by Lagash on 12/02/2019.
//  Copyright © 2019 ezCode. All rights reserved.
//

import UIKit
import Gloss

class Product: NSObject, Glossy {
    
    var prodID: Int
    var prodName: String
    var prodDesc: String
    var prodPhoto: String
    var prodPrice: Double
    var prodCatID: Int
    var prodUnit: Int = 0
    var prodTotalCostUnit: Double
    var prodPromotion: Promotion?
    
    required init?(json: JSON) {
        
        guard let productID: Int = "id" <~~ json else { return nil }
        
        prodID = productID
        prodName = "name" <~~ json ?? ""
        prodDesc = "description" <~~ json ?? ""
        prodPhoto = "photo" <~~ json ?? ""
        prodPrice = "price" <~~ json ?? 0.0
        prodCatID = "category_id" <~~ json ?? 0
        prodUnit = "prodUnit" <~~ json ?? 0
        prodTotalCostUnit = "prodTotalCostUnit" <~~ json ?? 0
        prodPromotion = "prodPromotion" <~~ json ?? nil
        
        /*if let tempProdPromotion: JSON = "prodPromotion" <~~ json {
            prodPromotion = Promotion(json: tempProdPromotion)
        }*/
    }
    
    func toJSON() -> JSON? {
        return jsonify([
                "id" ~~> self.prodID,
                "name" ~~> self.prodName,
                "description" ~~> self.prodDesc,
                "photo" ~~> self.prodPhoto,
                "price" ~~> self.prodPrice,
                "category_id" ~~> self.prodCatID,
                "prodUnit" ~~> self.prodUnit,
                "prodTotalCostUnit" ~~> self.prodTotalCostUnit,
                "prodPromotion" ~~> self.prodPromotion
            ])
    }
}
