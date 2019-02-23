//
//  MPPresenter.swift
//  MP
//
//  Created by Lagash on 12/02/2019.
//  Copyright © 2019 ezCode. All rights reserved.
//

import UIKit
import Gloss
import KeychainSwift

class MPPresenter: NSObject, MPPresenterProtocol {
    
    private var dataManager: DataManagerProtocol
    private var mainProductData: [Product] = []
    private var mainFilterProductData: [Product] = []
    private var mainCategoryData: [Category] = []
    private var mainPromotionData: [Promotion] = []
    private var mainShoppingCarData: ShoppingCar!
    private var mainView: MPViewProtocol
    private weak var mpUtil: MPUtils?
    
    required init(mainViewIn: MPViewProtocol, mpUtilIn: MPUtils) {
        mainView = mainViewIn
        mpUtil = mpUtilIn
        dataManager = DataManager.sharedInstance
        mainShoppingCarData = mpUtil?.giveMeShoppingCar() ?? ShoppingCar.init(totalUNIn: 0, totalCostIn: 0)
    }
    
    // MARK: Logic Methods
    func makeProductFilter(catIDIn: Int) {
        
        mainFilterProductData = []
        if catIDIn != 0 {
            for product in mainProductData {
                if product.prodCatID == catIDIn {
                    mainFilterProductData.append(product)
                }
            }
            mainView.setProductData(productDataIn: mainFilterProductData)
        }else{
            mainView.setProductData(productDataIn: mainProductData)
        }
    }
    
    func addProductToCar(productIn: Product) {
        
        if mainShoppingCarData.productData.count != 0 {
            for product in mainShoppingCarData.productData {
                if product.prodID == productIn.prodID {
                    product.prodUnit += 1
                    updateUIInfoUnit()
                    updateTotalCostShoppingCar()
                    mpUtil?.saveShoppingCar(shoppingCarIn: mainShoppingCarData)
                    return
                }
            }
            productIn.prodUnit = 1
            mainShoppingCarData.productData.append(productIn)
            updateUIInfoUnit()
            updateTotalCostShoppingCar()
            mpUtil?.saveShoppingCar(shoppingCarIn: mainShoppingCarData)
        }else {
            productIn.prodUnit = 1
            mainShoppingCarData.productData.append(productIn)
            updateUIInfoUnit()
            updateTotalCostShoppingCar()
            mpUtil?.saveShoppingCar(shoppingCarIn: mainShoppingCarData)
        }
    }
    
    func removeProductToCar(productIn: Product) {
        
        if mainShoppingCarData.productData.count != 0 {
            for (index, product) in mainShoppingCarData.productData.enumerated() {
                if product.prodID == productIn.prodID {
                    if product.prodUnit > 1 {
                        product.prodUnit -= 1
                        updateUIInfoUnit()
                        updateTotalCostShoppingCar()
                        mpUtil?.saveShoppingCar(shoppingCarIn: mainShoppingCarData)
                        return
                    }else{
                        product.prodUnit = 0
                        updateUIInfoUnit()
                        updateTotalCostShoppingCar()
                        mainShoppingCarData.productData.remove(at: index)
                        mpUtil?.saveShoppingCar(shoppingCarIn: mainShoppingCarData)
                        return
                    }
                }
            }
        }
    }
    
    private func updateUIInfoUnit() {
        
        if mainFilterProductData.count != 0 {
            for product in mainFilterProductData {
                for productCar in mainShoppingCarData.productData {
                    if product.prodID == productCar.prodID {
                        product.prodUnit = productCar.prodUnit
                    }
                }
            }
            mainView.setProductData(productDataIn: mainFilterProductData)
        }else{
            for product in mainProductData {
                for productCar in mainShoppingCarData.productData {
                    if product.prodID == productCar.prodID {
                        product.prodUnit = productCar.prodUnit
                    }
                }
            }
            mainView.setProductData(productDataIn: mainProductData)
        }
    }
    
    private func updateTotalCostShoppingCar() {
        
        mainShoppingCarData.totalCost = 0
        mainShoppingCarData.totalUN = 0
        for product in mainShoppingCarData.productData {
            mainShoppingCarData.totalUN += product.prodUnit
            var prodTotalCost: Double = 0
            var promoD = 0
            if product.prodPromotion != nil {
                for poli in product.prodPromotion!.promoPolicies {
                    if product.prodUnit >= poli.poMin {
                        promoD = poli.poDiscount
                    }
                }
            }
            
            prodTotalCost = product.prodPrice * Double(product.prodUnit)
            if promoD != 0 {
                let promoDiscount = prodTotalCost * Double((promoD / 100))
                prodTotalCost -= promoDiscount
            }
            
            product.prodTotalCostUnit = prodTotalCost
            mainShoppingCarData.totalCost += product.prodTotalCostUnit
        }
    }
    
    func getTotalItemsCar() -> String {
        
        var totalProducts = 0
        for product in mainShoppingCarData.productData {
            totalProducts += product.prodUnit
        }
        
        mainShoppingCarData.totalUN = totalProducts
        
        return String(totalProducts)
    }
    
    // MARK: API Calls
    func getProductData() {
        
        let handler = ResponseHandler(onSuccess: { info in
            
            let productJSONA = info as? Array<Any>
            if productJSONA != nil {
                for productJSON in productJSONA! {
                    if let tempProduct = Product(json: productJSON as! JSON) {
                        self.mainProductData.append(tempProduct)
                    }
                }
                
                self.updateUIInfoUnit()
                self.getPromotionsData()
            }
            
        }, onFailed: { error in
            self.onFailed(errorIn: error)
        })
        
        dataManager.getProductsData(handlerIn: handler)
    }
    
    func getCategoriesData() {
        
        let handler = ResponseHandler(onSuccess: { info in
            
            let catJSONA = info as? Array<Any>
            if catJSONA != nil {
                let allCat = Category(catIDIn: 0, catNameIn: "TODOS")
                self.mainCategoryData.append(allCat)
                for catJSON in catJSONA! {
                    if let tempCat = Category(json: catJSON as! JSON) {
                        self.mainCategoryData.append(tempCat)
                    }
                }
                
                self.mainView.setCategoryData(catDataIn: self.mainCategoryData)
            }
            
        }, onFailed: { error in
            self.onFailed(errorIn: error)
        })
        
        dataManager.getCategoriesData(handlerIn: handler)
    }
    
    func getPromotionsData() {
        
        let handler = ResponseHandler(onSuccess: { info in
            
            let promoJSONA = info as? Array<Any>
            if promoJSONA != nil {
                for promoJSON in promoJSONA! {
                    if let tempPromo = Promotion(json: promoJSON as! JSON) {
                        self.mainPromotionData.append(tempPromo)
                    }
                }
                
                if self.mainProductData.count != 0 {
                    for product in self.mainProductData {
                        for promo in self.mainPromotionData {
                            if product.prodCatID == promo.promoCatID {
                               product.prodPromotion = promo
                            }
                        }
                    }
                }
                
                self.updateUIInfoUnit()
            }
            
        }, onFailed: { error in
            self.onFailed(errorIn: error)
        })
        
        dataManager.getPromotionsData(handlerIn: handler)
    }
    
    func onFailed(errorIn: Any) {
        mainView.showSomeMsg(msgTitleIn: "Aconteceu um Erro", msgIn: errorIn as! String)
    }
}
