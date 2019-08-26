//
//  CipgSdk.swift
//  cipgSdk_Example
//
//  Created by Macbook Air on 19/08/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation
import UIKit

public class CipgSdk {
    public var delegate: CipgDelegate? = nil;
    
   public init(paymentUrl:String) {
       AppState.paymentUrl = paymentUrl
    }
    
    public func pay(view :UIViewController, charge: Charge){
    print("Pay method called...")
    
        AppState.currencyCode = charge.currencyCode
        AppState.orderId = charge.orderId
        AppState.merchantId = charge.merchantId
        AppState.customerEmail = charge.customerEmail
        AppState.prod = charge.productName
        AppState.amount = charge.amount
        
        let viewToDisplay = WebViewController()
        viewToDisplay.cipgDelegate = delegate
        view.present(viewToDisplay , animated: true, completion: nil)
    }
}
