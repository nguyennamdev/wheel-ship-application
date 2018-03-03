//
//  HomeOrdererController+Actions.swift
//  WheelShip
//
//  Created by Nguyen Nam on 3/3/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

extension HomeOrdererController {
    
    @objc func makeNewOrder(){
        guard let fromAddress = fromAddressTextField.text,
              let toAddress = toAddressTextField.text,
              let phoneReceiver = phoneReceiverTextField.text,
              let prepayment = prepaymentTextField.text,
              let price = priceTextField.text else { return }
        print(fromAddress, toAddress, phoneReceiver, prepayment, price)
    }
    
    @objc func endingEntryText(){
        view.endEditing(true)
    }
}

