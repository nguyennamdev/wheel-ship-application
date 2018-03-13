//
//  OdererEnterInfoController.swift
//  WheelShip
//
//  Created by Nguyen Nam on 3/12/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

extension OrdererEnterInfoController {
    
    func setupPageControl(){
        view.addSubview(pageControl)
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
    }
    
}
