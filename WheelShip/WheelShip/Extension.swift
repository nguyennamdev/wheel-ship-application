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

extension UIColor {
    public static func rgb(r:CGFloat , g:CGFloat, b:CGFloat) -> UIColor{
        return UIColor.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}

extension UITextField {
    
    func setupImageForLeftView(image:UIImage){
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 29, height: 24))
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 5, y: 0, width: 24, height: 24)
        view.addSubview(imageView)
        leftView = view
        leftViewMode = .always
    }
    
    func setupDefault(){
        self.backgroundColor = UIColor(white: 1, alpha: 0.3)
        self.textColor = UIColor.white
        self.borderStyle = .roundedRect
    }
}

extension String{
    func randomString() -> String{
        let letters:NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        var randomString = ""
        for _ in 0..<8
        {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        return randomString
    }
}

