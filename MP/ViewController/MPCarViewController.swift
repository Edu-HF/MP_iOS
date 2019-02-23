//
//  MPCarViewController.swift
//  MP
//
//  Created by Lagash on 12/02/2019.
//  Copyright © 2019 ezCode. All rights reserved.
//

import UIKit
import Nuke

class MPCarViewController: UIViewController {
    
    @IBOutlet weak var mainProducCarTV: UITableView!
    @IBOutlet weak var carTotalUnitLabel: UILabel!
    @IBOutlet weak var carTotalCostLabel: UILabel!
    var mpUtil: MPUtils!
    var mainSC: ShoppingCar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mainSC = mpUtil.giveMeShoppingCar() ?? ShoppingCar.init(totalUNIn: 0, totalCostIn: 0)
        mainProducCarTV.reloadData()
        updateCarValues()
    }
    
    private func setupView() {
        
        mpUtil = MPUtils()
        mainSC = mpUtil.giveMeShoppingCar() ?? ShoppingCar(totalUNIn: 0, totalCostIn: 0)
        mainProducCarTV.register(UINib(nibName: "ProductCarCell", bundle: nil), forCellReuseIdentifier: "ProdCarCell")
        mainProducCarTV.rowHeight = 100
        mainProducCarTV.separatorStyle = .none
    }
    
    private func updateCarValues() {
        carTotalUnitLabel.text = "UN " + String(mainSC.totalUN)
        carTotalCostLabel.text = "R$ " + String(format: "%.2f", mainSC.totalCost)
    }
    
    @objc private func showProductOff(_ sender: UIButton) {
        for product in mainSC.productData {
            if product.prodID == sender.tag {
                if product.prodPromotion != nil {
                    mpUtil.buildDialogAlert(titleIn: product.prodPromotion?.promoName ?? "", msgIn: mpUtil.makePromoDesc(promoIn: product.prodPromotion!))
                }
            }
        }
    }
    
    @objc private func showProductCostDetail(_ sender: UIButton) {
        for product in mainSC.productData {
            if product.prodID == sender.tag {
                mpUtil.buildDialogAlert(titleIn: product.prodName, msgIn: mpUtil.makeProductDesc(productIn: product))
            }
        }
    }
    
    @IBAction private func mainBuyBtnAct(_ sender: Any) {
        mpUtil.buildDialogAlert(titleIn: "Onde fica esse MercadoPago ???", msgIn: "O MercadoPago não possui a biblioteca atualizada para o Swift 4.2, WTF! 🤷🏽‍♂ 🤦🏽‍♂")
    }
}

extension MPCarViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainSC.productData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let prodCarCell = tableView.dequeueReusableCell(withIdentifier: "ProdCarCell") as! ProductCarTableViewCell
        prodCarCell.setupCell(productIn: mainSC.productData[indexPath.row], mpUtilIn: self.mpUtil)
        prodCarCell.cellProdCarOffBtn.addTarget(self, action: #selector(showProductOff(_:)), for: .touchUpInside)
        prodCarCell.cellProdCarPriceBtn.addTarget(self, action: #selector(showProductCostDetail(_:)), for: .touchUpInside)
        
        return prodCarCell
    }
}
