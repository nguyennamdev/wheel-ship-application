//
//  HistoryViewController+SetupViews.swift
//  WheelShip
//
//  Created by Nguyen Nam on 4/19/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

extension HistoryViewController{
    
    func setupStatusOrderSegment(){
        view.addSubview(statusOrderSegment)
        //x,y,w,h
        statusOrderSegment.anchorWithConstants(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor,topConstant: 12, leftConstant: 24, bottomConstant: 0, rightConstant: 24)
        statusOrderSegment.heightAnchor.constraint(equalToConstant: 34).isActive =  true
    }
    
    func setupOrdersCollectionView(){
        view.addSubview(ordersCollectionView)
        //x,y,w,h
        ordersCollectionView.anchorWithConstants(top: statusOrderSegment.bottomAnchor, left: view.leftAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, right: view.rightAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 12, rightConstant: 0)
    }
    
}
