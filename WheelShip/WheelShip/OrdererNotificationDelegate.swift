//
//  OrdererNotificationDelegate.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/23/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

protocol OrdererNotificationDelegate {
    
    func responseToShip(orderId:String, shipperId:String ,isAgree:Bool)
    
}
