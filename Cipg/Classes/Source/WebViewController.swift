//
//  WebViewController.swift
//  cipgSdk_Example
//
//  Created by Macbook Air on 19/08/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit
import WebKit
import ProgressHUD
import Alamofire
import SwiftyJSON

class WebViewController : UIViewController, UIWebViewDelegate {
    var cipgDelegate : CipgDelegate? =  nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
       super.init(nibName: nil, bundle:nil)
        self.setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        print("Setting up webViewController views...")
        
       //HeaderView Section
        let headerView : UIView = {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            return view
        }()
        
        let cancelButton : UIButton = {
            let button : UIButton = UIButton()
            button.setTitle("Cancel", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitleColor(UIColor.black, for: .normal)
            button.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            button.layer.cornerRadius = 5
            return button
        }()
         //HeaderView Section end
        
        //Body section
        let webViewBody : UIWebView = {
            let webView  = UIWebView()
            webView.translatesAutoresizingMaskIntoConstraints=false
            return webView
        }()
        
        
        view.addSubview(headerView)
        headerView.addSubview(cancelButton)
        view.addSubview(webViewBody)
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cancelButton.addTarget(self, action: #selector(self.popView), for: .touchUpInside)
        
        print("AppState base url")
        print(AppState.baseUrl)
        if(AppState.baseUrl == "" || AppState.baseUrl == "baseUrl should be passed here"){
            print("Invalid base url set")
            AppState.baseUrl = "https://wromgurl.com"
        }
        
        let url = "\(AppState.baseUrl)\(Constants.PAYMENT_URL)"
        var request  = URLRequest(url: (URL(string: url)!))
        let amount = AppState.amount.addingPercentEncoding(withAllowedCharacters: .alphanumerics)
        let params = "mercId=\(AppState.merchantId)&currCode=\(AppState.currencyCode)&amt=\(amount ?? "")&orderId=\(AppState.orderId)&prod=\(AppState.prod)&source=\(AppState.source)&email=\(AppState.customerEmail)"
        print("Loading webpage with param")
        ProgressHUD.show("loading, please wait...")
        print(params)
        request.httpMethod = "POST"
        request.httpBody = params.data(using: .utf8)
        webViewBody.delegate = self
        print(webViewBody.debugDescription)
        webViewBody.loadRequest(request)

        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate(
                [
                    headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                ])
        } else {
            // Fallback on earlier versions
            NSLayoutConstraint.activate(
                [
                    headerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 20),
                ])
        }
        
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            cancelButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            cancelButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor),
            
            webViewBody.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            webViewBody.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            webViewBody.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            webViewBody.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            ])
        

        
    }
    
    @objc func popView(){
        print("Pop View clicked")
        ProgressHUD.dismiss()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print("Content is about loading")
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
         print("Content finished loading")
         ProgressHUD.dismiss()
         let url = webView.request?.url
        
        //This url is to be handled
        if url?.absoluteString.contains(Constants.OUTCOME_URL) ?? false{
            print("Sdk outcome query")
            let transactref = url?.queryDictionary?[Constants.TRANSACTION_REF_KEY]
            let _ = url?.queryDictionary?[Constants.ORDER_ID_KEY]
            let errorMessage = url?.queryDictionary?[Constants.ERROR_MESSAGE_KEY]
            
    
            if !transactref!.isEmpty{
                self.cipgDelegate?.onSuccess(msg: transactref!)
                print("Payment successful")
                print("Verifiying transaction...")
                
                let parameters: Parameters = [
                    "Amount": AppState.amount,
                    "MerchantId": AppState.merchantId,
                    "CurrencyCode": AppState.currencyCode,
                    "OrderId": AppState.orderId,
                ]
                
                ProgressHUD.show("Validating transaction reference, please wait...")
                Alamofire.request("\(AppState.baseUrl)\(Constants.BASE_API_URL)\(Constants.VALIDATE_TRANSACTION_PATH)", method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
                    ProgressHUD.dismiss()
                    print("Validation result")
                    debugPrint(response)
                    
                    if let json = response.result.value {
                        print("JSON: \(json)")
                        print (JSON(json)["ResponseCode"])
                        if JSON(json)["ResponseCode"] == "00" {
                            //Trans ref validated successfullly
                            print ("Transacion reference validated successfully")
                            self.cipgDelegate?.onSuccess(msg:transactref!)
                        }else{
                            //Trans ref validation failed
                            let description = JSON(json)["ResponseDescription"]
                            print ("Error description  \(description)")
                            self.cipgDelegate?.onError(msg: description.stringValue)
                        }
                        
                    }
                    
                    if let error = response.error{
                        print("Error occurred")
                        print("error.localizedDescription")
                        self.cipgDelegate?.onError(msg: error.localizedDescription)
                    }
                    
                    self.popView()
                }
                
            }else  if !errorMessage!.isEmpty{
                 print("Error occured")
                 print(errorMessage as Any)
                self.cipgDelegate?.onError(msg: errorMessage!)
                popView()
                
            }else{
                print("An unknown sdkOutcome error occurred")
                self.cipgDelegate?.onError(msg: "An unknown sdkOutcome error occurred")
                popView()
            }

        }
         print(webView.request?.url! as Any)
        
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
         print("Content finished loading with error")
         ProgressHUD.dismiss()
         self.cipgDelegate?.onError(msg: error.localizedDescription)
         self.popView()
         print(error.localizedDescription)
    }
}

extension URL {
    var queryDictionary: [String: String]? {
        guard let query = self.query else { return nil}
        
        var queryStrings = [String: String]()
        for pair in query.components(separatedBy: "&") {
            
            let key = pair.components(separatedBy: "=")[0]
            
            let value = pair
                .components(separatedBy:"=")[1]
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? ""
            
            queryStrings[key] = value
        }
        return queryStrings
    }
}

