//
//  MPUtils.swift
//  MP
//
//  Created by Lagash on 12/02/2019.
//  Copyright © 2019 ezCode. All rights reserved.
//

import UIKit
import CDAlertView
import KeychainSwift

enum MPConstants: String {
    case MP_DEFAULT_NETWORK_ERROR   = "Ocorreu um erro ao tentar consultar as informações com o servidor. Por favor, verifique sua conexão com a internet"
    case MP_NETWORK_ERROR_400       = "Não conseguimos acessar as informações solicitadas. O servidor não responde Tente mais tarde"
    case MP_SHOPPING_CAR_NAME       = "shoppingCarData"
    case MP_MAIN_SERVER_URL         = "https://pastebin.com/raw/"
    case MP_PRODUCTS_URL            = "eVqp7pfX"
    case MP_CATEGORIES_URL          = "YNR2rsWe"
    case MP_PROMOTIONS_URL          = "R9cJFBtG"
}

class MPUtils: NSObject {
    
    func buildFilterBtn(viewC: UIViewController, selectorIn: Selector) {
        
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x:0.0, y:0.0, width:30, height:30)
        btn.setImage(UIImage(imageLiteralResourceName: "Filter_IC"), for: .normal)
        btn.addTarget(viewC, action: selectorIn, for: .touchUpInside)
        let navBtn = UIBarButtonItem(customView: btn)
        viewC.navigationItem.rightBarButtonItem = navBtn
    }
    
    func buildDialogAlert(titleIn: String, msgIn: String) {
        let dialogAlert = CDAlertView(title: titleIn, message: msgIn, type: .custom(image: UIImage(imageLiteralResourceName: "Info_IC")))
        dialogAlert.add(action: CDAlertViewAction(title: "Aceitar"))
        dialogAlert.show()
    }
    
    func makePromoDesc(promoIn: Promotion) -> String {
    
        var promoDesc = "Todos os produtos com esta promoção têm o seguinte desconto: \n\n"
    
        if promoIn.promoPolicies.count != 0 {
            for poli in promoIn.promoPolicies {
                promoDesc = promoDesc + "Com um mínimo de: " + String(poli.poMin) + " UN \n"
                promoDesc = promoDesc + "Você recebe um desconto de: " + String(poli.poDiscount) + "%\n\n"
            }
        }
    
        return promoDesc
    }
    
    func makeProductDesc(productIn: Product) -> String {
    
        var productDesc = productIn.prodName + " \n\n"
    
        productDesc += "Preço do produto: " + String(productIn.prodPrice) + "\n\n"
        
        if productIn.prodPromotion != nil {
            if productIn.prodPromotion?.promoPolicies.count != 0 {
                
                productDesc += "Um desconto será aplicado à sua compra, conforme aplicável: \n\n"
                
                for poli in productIn.prodPromotion!.promoPolicies {
                    productDesc += "Com um mínimo de: " + String(poli.poMin) + " UN \n"
                    productDesc += "Você recebe um desconto de: " + String(poli.poDiscount) + "% \n\n"
                }
                
                productDesc += "Número de unidades: " + String(productIn.prodUnit) + "\n"
                productDesc += "Preço com desconto aplicado: " + String(productIn.prodTotalCostUnit) + "\n"
            }
        }
    
        return productDesc
    }
    
    func giveMeOffApply(productIn: Product) -> String {
    
        var promoDesc = ""
        if productIn.prodPromotion != nil {
            for poli in productIn.prodPromotion!.promoPolicies {
                if productIn.prodUnit >= poli.poMin {
                    promoDesc = String(poli.poDiscount) + " %"
                }
            }
        }
        
        return promoDesc
    }
    
    func saveShoppingCar(shoppingCarIn: ShoppingCar) {
        
        let keyChain = KeychainSwift()
        let shoppingCarData = NSKeyedArchiver.archivedData(withRootObject: shoppingCarIn)
        keyChain.set(shoppingCarData, forKey: MPConstants.MP_SHOPPING_CAR_NAME.rawValue)
    }
    
    func giveMeShoppingCar() -> ShoppingCar? {
        
        let keyChain = KeychainSwift()
        let shoppingCarData = keyChain.getData(MPConstants.MP_SHOPPING_CAR_NAME.rawValue)
        if shoppingCarData != nil {
            return NSKeyedUnarchiver.unarchiveObject(with: shoppingCarData!) as? ShoppingCar
        }else{
            return nil
        }
    }
}
