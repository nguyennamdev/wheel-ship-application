//
//  OrdersHistoryDelegate.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/8/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Foundation

protocol OrdersHistoryDelegate {
    
    func deleteAOrderByOrderId(orderId:String)
    
    func editAOrderByOrderId(orderId:String)
    
}
