//
//  CatCollectionViewCell.swift
//  MP
//
//  Created by Lagash on 13/02/2019.
//  Copyright © 2019 ezCode. All rights reserved.
//

import UIKit

class CatCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellCatIV: UIImageView!
    @IBOutlet weak var cellCatName: UILabel!
    
    override func prepareForReuse() {
        
        cellCatIV.image = nil
        cellCatName.text = ""
    }
    
    func setupCell(catIn: Category) {
        
        prepareForReuse()
        cellCatIV.image = UIImage(imageLiteralResourceName: "CAT_IC_" + String(catIn.catID))
        cellCatName.text = catIn.catName
    }
    
}
