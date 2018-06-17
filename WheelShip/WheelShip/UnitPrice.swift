//
//  UnitPriceModel.swift
//  WheelShip
//
//  Created by Nguyen Nam on 4/7/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Foundation

class UnitPrice: NSObject {
    
    public var order: Order?
    public var prepayment: Double = 0
    public var feeShip: Double = 0
    public var priceOfWeight:Double?
    public var priceFragileOrder:Double? = 0
    public var priceOfDistance:Price?

    public var overheads:Double {
        return feeShip + prepayment + (priceOfWeight ?? 0) + (priceFragileOrder ?? 0)
    }
    
}


