//
//  MPViewInteractor.swift
//  MP
//
//  Created by Lagash on 15/02/2019.
//  Copyright © 2019 ezCode. All rights reserved.
//

import UIKit

protocol MPViewProtocol {
    
    func setProductData(productDataIn: [Product])
    func setCategoryData(catDataIn: [Category])
    func showSomeMsg(msgTitleIn: String, msgIn: String)
}
