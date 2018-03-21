//
//  HomeOrdererController+Actions.swift
//  WheelShip
//
//  Created by Nguyen Nam on 3/3/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

extension HomeOrdererController {
    
    @objc func showOrdererEnterInfo(){
//        guard let fromAddress = fromAddressTextField.text,
//            let toAddress = toAddressTextField.text else { return }
        // init order
        /*
        guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appdelegate.persistentContainer.viewContext
        self.order = Order(context: context)
        // set some value for order property
        self.order?.fromAddress = fromAddress
        self.order?.toAddress = toAddress
        self.order?.setFromLocation(value: (self.fromLocation?.coordinate)!)
        self.order?.setToLocation(value: (self.toLocation?.coordinate)!)*/
        // pushes ordererEnterInfoController
        let orderEnterInfoController = OrdererEnterInfoController()
        self.navigationController?.pushViewController(orderEnterInfoController, animated: false)
    }
    
    @objc func endingEntryText(){
        view.endEditing(true)
    }
    
}








