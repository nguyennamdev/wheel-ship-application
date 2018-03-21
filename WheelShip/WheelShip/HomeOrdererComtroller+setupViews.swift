
//  File.swift
//  WheelShip
//
//  Created by Nguyen Nam on 3/5/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

// setup views
extension HomeOrdererController {
    
    func setupFromAddressTextField(){
        view.addSubview(originAddressTextField)
        originAddressTextField.anchorWithWidthHeightConstant(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 24, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant:50)
    }
    
    func setupToAddressTextField(){
        view.addSubview(destinationAddressTextField)
        destinationAddressTextField.anchorWithWidthHeightConstant(top: originAddressTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 12, widthConstant: 0, heightConstant: 50)
    }
    
    func setupGoogleMapsView(){
        view.addSubview(mapsView)
        mapsView.anchorWithConstants(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: pageControl.topAnchor, right: view.rightAnchor)
    }
    
    func setupPageControl(){
        view.addSubview(pageControl)
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant:0).isActive = true
    }
}
