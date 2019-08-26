//
//  CipgDelegate.swift
//  cipgSdk_Example
//
//  Created by Macbook Air on 20/08/2019.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

public protocol CipgDelegate{
    func onError(msg:String)
    func onSuccess(msg:String)
}
