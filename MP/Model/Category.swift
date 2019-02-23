//
//  Category.swift
//  MP
//
//  Created by Lagash on 12/02/2019.
//  Copyright © 2019 ezCode. All rights reserved.
//

import UIKit
import Gloss

class Category: NSObject, Glossy {
    
    var catID: Int
    var catName: String
    
    init(catIDIn: Int, catNameIn: String) {
        
        catID = catIDIn
        catName = catNameIn
    }
    
    required init?(json: JSON) {
        
        guard let categoryID: Int = "id" <~~ json else { return nil }
        
        catID = categoryID
        catName = "name" <~~ json ?? ""
    }
    
    func toJSON() -> JSON? {
        return nil
    }
}
