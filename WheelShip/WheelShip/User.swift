//
//  UserModel.swift
//  WheelShip
//
//  Created by Nguyen Nam on 4/7/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Foundation

class User: NSCoding {
    
    
    public var uid: String?
    public var name: String?
    public var email: String?
    public var password: String?
    public var imageUrl: String?
    public var phoneNumber: String?
    public var isActive: Int?
    public var userType: TypeOfUser?
    
    public var orders:Set<Order>?
    
    
    init() {
        
    }
  
    init(uid:String, name:String, email:String, password:String, imageUrl:String? = nil, phoneNumber:String?, isActive:Int? = nil, userType:TypeOfUser) {
        self.uid = uid
        self.name = name
        self.email = email
        self.password = password
        self.imageUrl = imageUrl
        self.phoneNumber = phoneNumber
        self.isActive = isActive
        self.userType = userType
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.uid, forKey: "uid")
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.email, forKey: "email")
        aCoder.encode(self.password, forKey: "password")
        aCoder.encode(self.imageUrl, forKey: "imageUrl")
        aCoder.encode(self.phoneNumber, forKey: "phoneNumber")
        aCoder.encode(self.isActive, forKey: "isActive")
        aCoder.encode(self.userType?.rawValue, forKey: "userType")
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let uid = aDecoder.decodeObject(forKey: "uid") as! String
        let name = aDecoder.decodeObject(forKey: "name") as! String
        let email = aDecoder.decodeObject(forKey: "email") as! String
        let password = aDecoder.decodeObject(forKey: "password") as! String
        let imageUrl = aDecoder.decodeObject(forKey: "imageUrl") as? String
        let phoneNumber = aDecoder.decodeObject(forKey: "phoneNumber") as! String
        let isActive = aDecoder.decodeObject(forKey: "isActive") as! Int
        let userTypeRaw = aDecoder.decodeObject(forKey: "userType") as! Int
        do {
            let userType:TypeOfUser = TypeOfUser(rawValue: userTypeRaw)!
            self.init(uid: uid, name: name, email: email, password: password, imageUrl: imageUrl, phoneNumber: phoneNumber, isActive: isActive, userType: userType)
        }
    }
    
    public func setValueWithDictionary(dictionary: NSDictionary){
        self.uid = dictionary.value(forKey: "uid") as? String
        self.name = dictionary.value(forKey: "name") as? String
        self.email = dictionary.value(forKey: "email") as? String
        self.password = dictionary.value(forKey: "password") as? String
        self.password = dictionary.value(forKey: "imageUrl") as? String
        self.phoneNumber = dictionary.value(forKey: "phoneNumber") as? String
        self.isActive = dictionary.value(forKey: "isActive") as? Int
        self.userType = TypeOfUser(rawValue: dictionary.value(forKey: "isShipper") as! Int)
    }
}
