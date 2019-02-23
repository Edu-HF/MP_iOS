//
//  ProductTableViewCell.swift
//  MP
//
//  Created by Lagash on 13/02/2019.
//  Copyright © 2019 ezCode. All rights reserved.
//

import UIKit
import Nuke

class ProductTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var cellProdIV: UIImageView!
    @IBOutlet weak var cellProdName: UILabel!
    @IBOutlet weak var cellProdPrice: UILabel!
    @IBOutlet weak var cellProdUnit: UILabel!
    @IBOutlet weak var cellProdOffBtn: UIButton!
    @IBOutlet weak var cellProdRemoveBtn: UIButton!
    @IBOutlet weak var cellProdAddBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        
        cellProdIV.image = nil
        cellProdOffBtn.isHidden = true
        cellProdOffBtn.tag = 0
        cellProdRemoveBtn.tag = 0
        cellProdAddBtn.tag = 0
        cellProdName.text = ""
        cellProdPrice.text = ""
        cellProdUnit.text = ""
    }
    
    func setupCell(productIn: Product) {
        
        loadImage(with: URL(string: productIn.prodPhoto)!, into:  cellProdIV)
        cellProdName.text = productIn.prodName
        cellProdPrice.text = "R$ " + String(format: "%.2f", productIn.prodPrice)
        cellProdUnit.text = "UN " + String(productIn.prodUnit)
        cellProdRemoveBtn.tag = productIn.prodID
        cellProdAddBtn.tag = productIn.prodID
        
        if productIn.prodPromotion != nil {
            cellProdOffBtn.isHidden = false
            cellProdOffBtn.tag = productIn.prodID
        }
        
        selectionStyle = .none
    }

}
