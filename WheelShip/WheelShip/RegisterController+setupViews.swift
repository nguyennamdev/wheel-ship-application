//
//  RegisterController+setupViews.swift
//  WheelShip
//
//  Created by Nguyen Nam on 3/5/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

// setup views
extension RegisterController {
    
    // MARK : setup view functions
    func setupBackgroundView(){
        view.addSubview(backgroundGradientView)
        backgroundGradientView.frame = view.frame
    }
    
    func setupBackButton(){
        view.addSubview(backButton)
        backButton.anchorWithWidthHeightConstant(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 40, heightConstant: 40)
    }
    
    func setupLogoLabel(){
        view.addSubview(titleLabel)
        titleLabel.anchorWithConstants(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 24)
        titleLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
    }
    
    // new view = view will to set up
    func setupATextField(newView:UITextField, bottomOf oldView:UIView){
        view.addSubview(newView)
        newView.anchorWithWidthHeightConstant(top: oldView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 12, leftConstant: 24, bottomConstant: 0, rightConstant: 24 , widthConstant: 0, heightConstant: 45)
        newView.delegate = self
    }
    
    func setupRegisterButton(){
        view.addSubview(continueButton)
        continueButton.anchorWithWidthHeightConstant(top: repasswordTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 55)
    }
    
}
