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
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 41, height: 25))
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 8, y: 0, width: 25, height: 25)
        view.addSubview(imageView)
        leftView = view
        leftViewMode = .always
        imageView.center = view.center
    }
    
    func setupDefault(){
        self.textColor = UIColor.black
        self.borderStyle = .roundedRect
        self.backgroundColor = UIColor.white
        self.clearButtonMode = .always
        self.font = UIFont.boldSystemFont(ofSize: 13)
    }
    
    func setDefaultWithCustomBoder(){
        self.backgroundColor = UIColor.white
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 0.5
        self.font = UIFont.boldSystemFont(ofSize: 13)
        self.clearButtonMode = .always
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

extension Formatter {
    static let withUnderDots: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = "."
        formatter.numberStyle = .decimal
        return formatter
    }()
}
extension Double{
    func formatedNumberWithUnderDots() -> String{
        return Formatter.withUnderDots.string(for: self) ?? ""
    }
}
