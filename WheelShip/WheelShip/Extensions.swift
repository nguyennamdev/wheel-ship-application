//
//  Extensions.swift
//  WheelShip
//
//  Created by Nguyen Nam on 1/26/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

extension UIColor {
    public static func rgb(r:CGFloat , g:CGFloat, b:CGFloat) -> UIColor{
        return UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
