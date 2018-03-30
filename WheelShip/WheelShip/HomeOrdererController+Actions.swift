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
        // init order
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appdelegate.persistentContainer.viewContext
        self.order = Order(context: context)
        // set some value for order property
        self.order?.originAddress = originAddress
        self.order?.destinationAddress = destinationAddress
        self.order?.originLocation = originLocation
        self.order?.destinationLocation = destinationLocation
        // push to ordererEnterInfoController
        let orderEnterInfoController = OrdererEnterInfoController()
        orderEnterInfoController.order = order
        self.navigationController?.pushViewController(orderEnterInfoController, animated: false)
    }
    
    @objc func endingEntryText(){
        view.endEditing(true)
    }
    
}








