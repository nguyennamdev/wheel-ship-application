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
        let order = createDummyOrder()
        print(order!)
        DispatchQueue.main.async {
            orderConfirmationController.order = order!
            self.navigationController?.pushViewController(orderConfirmationController, animated: false)
        }
        
    }
    @objc func isFragileSwitchValueChanged(sender:UISwitch){
        
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
        if let appdelegate = UIApplication.shared.delegate as? AppDelegate{
            let context = appdelegate.persistentContainer.viewContext
            let order = Order(context: context)
            order.originAddress = "ho guom, hai ba trung, ha noi"
            order.destinationAddress = "176 truong dinh, hoang mai, ha noi"
            order.phoneReceiver = "01657886310"
            order.isFragile = true
            order.weight = "3 - 5kg"
            order.note = "can ship gap"
            order.prepayment = 400000
            order.feeShip = 20000
            return order
        }
        return nil
    }
}
