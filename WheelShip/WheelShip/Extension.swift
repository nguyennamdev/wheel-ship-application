//
//  Extension.swift
//  WheelShip
//
//  Created by Nguyen Nam on 1/29/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

extension UserDefaults{
    
    enum UserDefaultKeys:String{
        case isLoggedIn
        case isUser
    }
    
    func setIsLoggedIn(value:Bool){
        set(value, forKey: UserDefaultKeys.isLoggedIn.rawValue)
        synchronize()
    }
    
    func getIsLoggedIn() -> Bool {
        return bool(forKey: UserDefaultKeys.isLoggedIn.rawValue)
    }
    
}

extension UIView{
    
    func anchorWithConstants(top:NSLayoutYAxisAnchor?, left:NSLayoutXAxisAnchor? , bottom:NSLayoutYAxisAnchor? , right:NSLayoutXAxisAnchor? , topConstant : CGFloat = 0, leftConstant:CGFloat = 0, bottomConstant:CGFloat = 0, rightConstant:CGFloat = 0){
        translatesAutoresizingMaskIntoConstraints = false
        
        if let topViewAnchor = top{
            topAnchor.constraint(equalTo: topViewAnchor, constant: topConstant).isActive = true
        }
        if let bottomViewAnchor = bottom{
            bottomAnchor.constraint(equalTo: bottomViewAnchor, constant: -bottomConstant).isActive = true
        }
        if let leftViewAnchor = left{
            leftAnchor.constraint(equalTo: leftViewAnchor, constant: leftConstant).isActive = true
        }
        if let rightViewAnchor = right
        {
            rightAnchor.constraint(equalTo: rightViewAnchor, constant: -rightConstant).isActive = true
        }
    }
    
    func anchorWithWidthHeightConstant(top:NSLayoutYAxisAnchor?, left:NSLayoutXAxisAnchor? , bottom:NSLayoutYAxisAnchor? , right:NSLayoutXAxisAnchor? , topConstant : CGFloat = 0, leftConstant:CGFloat = 0, bottomConstant:CGFloat = 0, rightConstant:CGFloat = 0, widthConstant:CGFloat = 0, heightConstant:CGFloat = 0){
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let topViewAnchor = top{
            topAnchor.constraint(equalTo: topViewAnchor, constant: topConstant).isActive = true
        }
        if let bottomViewAnchor = bottom{
            bottomAnchor.constraint(equalTo: bottomViewAnchor, constant: -bottomConstant).isActive = true
        }
        if let leftViewAnchor = left{
            leftAnchor.constraint(equalTo: leftViewAnchor, constant: leftConstant).isActive = true
        }
        if let rightViewAnchor = right
        {
            rightAnchor.constraint(equalTo: rightViewAnchor, constant: -rightConstant).isActive = true
        }
        
        if widthConstant > 0{
            widthAnchor.constraint(equalToConstant: widthConstant).isActive = true
        }
        if heightConstant > 0
        {
            heightAnchor.constraint(equalToConstant: heightConstant).isActive = true
        }
    }
    
}
