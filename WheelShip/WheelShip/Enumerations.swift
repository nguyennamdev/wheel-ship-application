//
//  StateOfUser.swift
//  WheelShip
//
//  Created by Nguyen Nam on 2/5/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Foundation

enum UserState:Int {
    case isActive // raw value of 0
    case isBlock  // raw value of 1
}

enum TypeOfUser:Int{
    case isOrderer // raw value of 0
    case isShipper // raw value of 1
}

enum OrderStage:Int{
    case waitingShipper // raw value of 0
    case hadShipper     // raw value of 1
}
