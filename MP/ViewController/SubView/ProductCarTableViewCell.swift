//
//  ProductCarTableViewCell.swift
//  MP
//
//  Created by Lagash on 13/02/2019.
//  Copyright © 2019 ezCode. All rights reserved.
//

import UIKit
import Nuke

class ProductCarTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellProdCarIV: UIImageView!
    @IBOutlet weak var cellProdCarName: UILabel!
    @IBOutlet weak var cellProdCarUnit: UILabel!
    @IBOutlet weak var cellProdCarOffBtn: UIButton!
    @IBOutlet weak var cellProdCarPriceBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        
        cellProdCarIV.image = nil
        cellProdCarOffBtn.isHidden = true
        cellProdCarName.text = ""
        cellProdCarUnit.text = ""
        cellProdCarOffBtn.setTitle("", for: .normal)
        cellProdCarOffBtn.tag = 0
        cellProdCarPriceBtn.setTitle("", for: .normal)
        cellProdCarPriceBtn.tag = 0
    }
    
    func setupCell(productIn: Product, mpUtilIn: MPUtils) {
        
        prepareForReuse()
        
        loadImage(with: URL(string: productIn.prodPhoto)!, into:  cellProdCarIV)
        cellProdCarName.text = productIn.prodName
        cellProdCarPriceBtn.setTitle("R$ " + String(format: "%.2f", productIn.prodTotalCostUnit), for: .normal)
        cellProdCarPriceBtn.tag = productIn.prodID
        cellProdCarUnit.text = "UN " + String(productIn.prodUnit)
        
        if productIn.prodPromotion != nil {
            let prodOff = mpUtilIn.giveMeOffApply(productIn: productIn)
            if prodOff != "" {
                cellProdCarOffBtn.isHidden = false
                cellProdCarOffBtn.tag = productIn.prodID
                cellProdCarOffBtn.tag = productIn.prodID
                cellProdCarOffBtn.setTitle(prodOff, for: .normal)
            }
        }
        
        selectionStyle = .none
    }

}
