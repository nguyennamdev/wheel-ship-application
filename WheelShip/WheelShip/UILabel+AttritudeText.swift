//
//  UILabel+AttritudeText.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/10/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

extension UILabel {
    
    func setAttitudeString(title:(String,UIColor),content:(String,UIColor)) {
        let attritude = NSMutableAttributedString(string: title.0, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: title.1])
        
        attritude.append(NSAttributedString(string: content.0, attributes: [NSAttributedStringKey.foregroundColor: content.1, NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 13)]))
        self.attributedText = attritude
    }
    
    func setAttitudeString(content:(String, UIColor, UIFont)){
        let attribute = NSAttributedString(string: content.0, attributes: [NSAttributedStringKey.foregroundColor: content.1, NSAttributedStringKey.font : content.2])
        self.attributedText = attribute
    }
     
}
