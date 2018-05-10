//
//  OrdererEnterInfoController+Actions.swift
//  WheelShip
//
//  Created by Nguyen Nam on 3/16/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

extension OrdererEnterInfoController {
    
    @objc func showOrderConfirmationController(){
        let orderConfirmationController = OrderConfirmationController(collectionViewLayout: UICollectionViewFlowLayout())
        self.order?.unitPrice = self.unitPrice;
        orderConfirmationController.order = order!
        self.navigationController?.pushViewController(orderConfirmationController, animated: false)
        
    }
    @objc func isFragileSwitchValueChanged(sender:UISwitch){
        if sender.isOn {
            unitPrice?.priceFragileOrder = self.dummyPriceFragileOder
            self.order?.isFragile = true;
        }else {
            unitPrice?.priceFragileOrder = 0
            self.order?.isFragile = false;
        }
        self.updateOverheadsLabel()
    }
    
    @objc func showWeightPicker(){
        if weightPickerViewIsShowing{
            heightConstaintOfWeightPickerView?.constant = 0
            weightPickerViewIsShowing = false
        }else{
            heightConstaintOfWeightPickerView?.constant = 100
            weightPickerViewIsShowing = true
        }
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func viewEndEdit(){
        view.endEditing(true)
        heightConstaintOfWeightPickerView?.constant = 0
        UIView.animate(withDuration: 0.5, delay: 0.1, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    // func used to test order
    func createDummyOrder() -> Order? {
        /*
         let order = Order(context: context)
         order.originAddress = "ho guom, hai ba trung, ha noi"
         order.destinationAddress = "176 truong dinh, hoang mai, ha noi"
         order.phoneReceiver = "01657886310"
         order.isFragile = true
         order.weight = "3 - 5kg"
         order.note = "can ship gap"
         return order
         }*/
        return nil
    }
    
    func createDummyUnitPrice() -> UnitPrice? {
        /*
         let unitPrice = UnitPrice(context: context)
         unitPrice.prepayment = 200000
         unitPrice.feeShip = 20000
         unitPrice.priceFragileOrder = 10000
         unitPrice.priceOfWeight = 5000
         return unitPrice
         }*/
        return nil
    }
}
