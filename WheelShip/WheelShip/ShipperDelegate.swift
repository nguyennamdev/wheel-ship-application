//
//  ShipperDelegate.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/21/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Foundation


@objc protocol ShipperDelegate {
    
    func presentResponseResult(title:String, message:String)
   
    @objc optional func unsaveOrder(orderId:String, userId:String)
    
    @objc optional func shipperCall(phoneOrderer:String, phoneReceiver:String)
    
}
