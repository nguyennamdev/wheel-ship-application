//
//  PopupEntryPhongNumber+setupViews.swift
//  WheelShip
//
//  Created by Nguyen Nam on 3/5/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

extension PopupEntryPhoneNumber {
    
    // MARK : setup views

    func setupGradientView(){
        view.addSubview(gradientBackground)
        gradientBackground.frame = view.frame
    }
    
    func setupBackButton(){
        view.addSubview(backButton)
        backButton.anchorWithWidthHeightConstant(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 24, leftConstant: 16, bottomConstant: 0, rightConstant: 0, widthConstant: 40, heightConstant: 40)
    }
    
    func setupIconImageView(){
        view.addSubview(iconImageView)
        iconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 130).isActive = true
    }
    
    func setupTitleTextView(){
        view.addSubview(titleTextView)
        titleTextView.anchorWithWidthHeightConstant(top: iconImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 12, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 120)
    }
    
    func setupPhoneNumberTextField(){
        view.addSubview(phoneNumberTextField)
        phoneNumberTextField.anchorWithWidthHeightConstant(top: titleTextView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 24, leftConstant: 25, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 50)
    }
    
    func setupOKButton(){
        view.addSubview(okButton)
        okButton.anchorWithWidthHeightConstant(top: phoneNumberTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 12, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 50)
    }
}
