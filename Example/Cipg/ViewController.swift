//
//  ViewController.swift
//  Cipg
//
//  Created by AppzoneTech on 08/26/2019.
//  Copyright (c) 2019 AppzoneTech. All rights reserved.
//

import UIKit
import Cipg

class ViewController: UIViewController, CipgDelegate{
    var cipgSdk : CipgSdk? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cipgSdk = CipgSdk(paymentUrl: "baseUrl should be passed here")
        self.setUpViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpViews(){
        let payButton : UIButton = {
            let button : UIButton = UIButton()
            button.setTitle("Pay", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitleColor(UIColor.white, for: .normal)
            button.backgroundColor = UIColor.purple
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.layer.cornerRadius = 5
            return button
        }()
        
        view.addSubview(payButton);
        
        NSLayoutConstraint.activate(
            [
                payButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
                payButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                payButton.widthAnchor.constraint(equalToConstant: 300),
                payButton.heightAnchor.constraint(equalToConstant: 50)
            ])
        
        payButton.addTarget(self, action: #selector(self.actionPay), for: .touchUpInside)
        
    }
    
    @objc func actionPay() {
        var charge = Charge()
        charge.amount = "2000"
        charge.currencyCode = "566"
        charge.customerEmail = "jl1aw1al@appzonegroup.com"
        charge.merchantId = "00037"
        charge.productName = "TestMerchant"
        charge.orderId  = "9163090"
        
        cipgSdk?.delegate = self
        cipgSdk?.pay(view: self, charge: charge);
    }
    
    
    func onError(msg: String) {
        print("OnError called from main app")
        print(msg)
    }
    
    func onSuccess(msg: String) {
        print("OnSuccess called from main app")
        print(msg)
    }
}


