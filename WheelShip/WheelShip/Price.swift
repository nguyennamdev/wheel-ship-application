//
//  Price.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/11/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Foundation

class Price{
    
    public var pId:String?
    public var name:String?
    public var text:String?
    public var category:String?
    public var value:Double?
    
    
    init(_ pId:String,_ name:String,_ text:String,_ value:Double) {
        self.pId = pId
        self.name = name
        self.text = text
        self.value = value
    }
    
    init() {
    }
    
    func setValueWithKey(value:[String:Any]){
        self.pId = value["pId"] as? String
        self.name = value["name"] as? String
        self.text = value["text"] as? String
        self.category = value["category"] as? String
        self.value = value["value"] as? Double
    }
    
}
