//
//  ConfirmationItem.swift
//  WheelShip
//
//  Created by Nguyen Nam on 3/20/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//
import UIKit

public class ConfirmationItem: NSObject {
    
    // properties
    var image:UIImage?
    var title:String?
    var content:String?
    
    init(image: UIImage, title: String, content: String) {
        self.image = image
        self.title = title
        self.content = content
    }
    
}
