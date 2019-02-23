//
//  Promotion.swift
//  MP
//
//  Created by Lagash on 12/02/2019.
//  Copyright © 2019 ezCode. All rights reserved.
//

import UIKit
import Gloss

class Promotion: NSObject, Glossy {
    
    var promoName: String
    var promoCatID: Int
    var promoPolicies: [Policies]
    
    required init?(json: JSON) {
        
        guard let promoPoli: [Any] = "policies" <~~ json else { return nil }
        
        promoName = "name" <~~ json ?? ""
        promoCatID = "category_id" <~~ json ?? 0
        promoPolicies = "policies" <~~ json ?? []

        for poli in promoPoli {
            let tempPoli = Policies(json: poli as! JSON)
            if tempPoli != nil {
                promoPolicies.append(tempPoli!)
            }
        }
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "name" ~~> self.promoName,
            "category_id" ~~> self.promoCatID,
            "policies" ~~> self.promoPolicies
            ])
    }
}

class Policies: NSObject, Glossy {
    
    var poMin: Int
    var poDiscount: Int
    
    required init?(json: JSON) {
        
        guard let policyMin: Int = "min" <~~ json else { return nil }
        
        poMin = policyMin
        poDiscount = "discount" <~~ json ?? 0
    }
    
    func toJSON() -> JSON? {
        return jsonify([
            "min" ~~> self.poMin,
            "discount" ~~> self.poDiscount
            ])
    }
}
