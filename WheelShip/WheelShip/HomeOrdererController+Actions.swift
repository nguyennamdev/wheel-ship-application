//
//  HomeOrdererController+Actions.swift
//  WheelShip
//
//  Created by Nguyen Nam on 3/3/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import CoreLocation

extension HomeOrdererController {
    @objc func showOrdererEnterInfo(){
        guard let originAddress = originAddressTextField.text,
            let destinationAddress = destinationAddressTextField.text,
            let originLocation = self.originLocation,
            let destinationLocation = self.destinationLocation else { return }
        self.order?.originAddress = originAddress
        self.order?.originLocation = originLocation
        self.order?.destinationAddress = destinationAddress
        self.order?.destinationLocation = destinationLocation;
        self.order?.orderId = String().randomString();
        // push to ordererEnterInfoController
        let orderEnterInfoController = OrdererEnterInfoController()
        orderEnterInfoController.order = order
        orderEnterInfoController.unitPrice = self.unitPrice
        self.navigationController?.pushViewController(orderEnterInfoController, animated: false)
    }
    
    @objc func endingEntryText(){
        view.endEditing(true)
    }
    
}








