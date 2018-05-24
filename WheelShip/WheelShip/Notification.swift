//
//  Notification.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/22/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Foundation

class Notification {
    
    var userId:String
    var name: String
    var phone: String
    var userImageUrl:String?
    
    init(userId: String, name:String, phone:String, imageUrl:String?) {
        self.userId = userId
        self.name = name
        self.phone = phone
        self.userImageUrl = imageUrl
    }
    
    init() {
        userId = ""
        name = ""
        phone = ""
    }
    
    public func setValueWithDictionary(dictionary:NSDictionary){
        self.userId = dictionary.value(forKeyPath: "userData.uid") as! String
        self.name = dictionary.value(forKeyPath: "userData.name") as! String
        self.phone = dictionary.value(forKeyPath: "userData.phoneNumber") as! String
        self.userImageUrl = dictionary.value(forKeyPath: "userData.imageUrl") as? String
    }
    

}
