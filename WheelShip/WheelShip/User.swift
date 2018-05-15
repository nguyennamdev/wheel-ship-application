//
//  UserModel.swift
//  WheelShip
//
//  Created by Nguyen Nam on 4/7/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Foundation

class User: NSObject {
    
    public var uid: String?
    public var name: String?
    public var email: String?
    public var password: String?
    public var imageUrl: String?
    public var phoneNumber: String?
    public var isActive: Int16?
    public var isShipper: TypeOfUser?
    
    public var orders:Set<Order>?
    
    override init() {
    }
    
}
