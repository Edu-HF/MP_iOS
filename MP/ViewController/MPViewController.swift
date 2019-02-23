//
//  MPViewController.swift
//  MP
//
//  Created by Lagash on 12/02/2019.
//  Copyright © 2019 ezCode. All rights reserved.
//

import UIKit
import Nuke
import SkeletonView

class MPViewController: UIViewController {
    
    @IBOutlet weak var mainProductTV: UITableView!
    @IBOutlet weak var mainCatFilterCV: UICollectionView!
    
    private var mainMPP: MPPresenterProtocol!
    lazy var productsData: [Product] = []
    lazy var catData: [Category] = []
    lazy var mainMPUtil = MPUtils()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        showSkeletonTable()
    }
    
    private func setupView() {
        
        mainMPP = MPPresenter(mainViewIn: self, mpUtilIn: mainMPUtil)
        mainMPP.getProductData()
        mainMPP.getCategoriesData()
        
        mainProductTV.register(UINib(nibName: "ProductCell", bundle: nil), forCellReuseIdentifier: "ProdCell")
        mainCatFilterCV.register(UINib(nibName: "CatCell", bundle: nil), forCellWithReuseIdentifier: "CatCell")
        mainCatFilterCV.isHidden = true
        mainProductTV.rowHeight = 140
        mainProductTV.separatorStyle = .none
        
        
        mainMPUtil.buildFilterBtn(viewC: self, selectorIn: #selector(showCatFilter))
        updateCarBadge()
        
    }
    
    private func showSkeletonTable() {
        mainProductTV.isSkeletonable = true
        let baseGC = SkeletonGradient(baseColor: UIColor.midnightBlue)
        mainProductTV.showGradientSkeleton(usingGradient: baseGC)
        mainProductTV.startSkeletonAnimation()
    }
    
    @objc private func showCatFilter() {
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: {
                if self.mainCatFilterCV.isHidden {
                    self.mainCatFilterCV.isHidden = false
                    self.mainCatFilterCV.reloadData()
                }else {
                    self.mainCatFilterCV.isHidden = true
                }
            })
        }
    }
    
    @objc private func addProductToCar(_ sender: UIButton) {
        for product in productsData {
            if product.prodID == sender.tag {
                mainMPP.addProductToCar(productIn: product)
                updateCarBadge()
            }
        }
    }
    
    @objc private func removeProductToCar(_ sender: UIButton) {
        for product in productsData {
            if product.prodID == sender.tag {
                mainMPP.removeProductToCar(productIn: product)
                updateCarBadge()
            }
        }
    }
    
    @objc private func showProductOff(_ sender: UIButton) {
        for product in productsData {
            if product.prodID == sender.tag {
                if product.prodPromotion != nil {
                    mainMPUtil.buildDialogAlert(titleIn: product.prodPromotion?.promoName ?? "", msgIn: mainMPUtil.makePromoDesc(promoIn: product.prodPromotion!))
                }
            }
        }
    }
    
    private func updateCarBadge() {
        
        if let tabItems = tabBarController?.tabBar.items {
            let carTab: UITabBarItem = tabItems[1]
            carTab.badgeValue = mainMPP.getTotalItemsCar()
        }
    }
}

extension MPViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let prodCell = tableView.dequeueReusableCell(withIdentifier: "ProdCell") as! ProductTableViewCell
        
        prodCell.setupCell(productIn: productsData[indexPath.row])
        prodCell.cellProdOffBtn.addTarget(self, action: #selector(showProductOff(_:)), for: .touchUpInside)
        prodCell.cellProdAddBtn.addTarget(self, action: #selector(addProductToCar(_:)), for: .touchUpInside)
        prodCell.cellProdRemoveBtn.addTarget(self, action: #selector(removeProductToCar(_:)), for: .touchUpInside)
        
        return prodCell
    }
}

extension MPViewController: SkeletonTableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func collectionSkeletonView(_ skeletonView: UITableView, cellIdentifierForRowAt indexPath: IndexPath) -> ReusableCellIdentifier {
        return "ProdCell"
    }
    
}

extension MPViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let catCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CatCell", for: indexPath) as! CatCollectionViewCell
        
        catCell.setupCell(catIn: catData[indexPath.row])
        
        return catCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showCatFilter()
        mainMPP.makeProductFilter(catIDIn: catData[indexPath.row].catID)
    }
}

extension MPViewController: MPViewProtocol {
    
    func setProductData(productDataIn: [Product]) {
        self.productsData = productDataIn
        self.mainProductTV.hideSkeleton()
        self.mainProductTV.reloadData()
    }
    
    func setCategoryData(catDataIn: [Category]) {
        self.catData = catDataIn
        self.mainCatFilterCV.reloadData()
    }
    
    func showSomeMsg(msgTitleIn: String, msgIn: String) {
        mainMPUtil.buildDialogAlert(titleIn: msgTitleIn, msgIn: msgIn)
    }

}
