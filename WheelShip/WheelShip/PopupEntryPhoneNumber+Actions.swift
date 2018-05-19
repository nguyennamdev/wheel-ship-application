//
//  PopupEntryPhoneNumber+Extension.swift
//  WheelShip
//
//  Created by Nguyen Nam on 2/5/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import Alamofire



extension PopupEntryPhoneNumber {
    
    // MARK: Actions
    
    @objc func handleTapReturn(){
        view.endEditing(true)
    }
    
    @objc func handleUserPhoneNumber(){
        if phoneNumberTextField.checkTextIsPhoneNumber() {
            guard let phoneNumber = phoneNumberTextField.text else { return }
            // check user edit information or create new a user
            if userToEdit != nil {
                if let userId = self.userToEdit?.uid {
                    handleUpdatePhoneNumber(phoneNumber: phoneNumber, userId: userId)
                }
            }else{
                // to create new user
                handleAddNewUser()
            }
        }else{
            phoneNumberTextField.text = "Số điện thoại sai định dạng"
            phoneNumberTextField.textColor = UIColor.red
        }
    }
    
    // MARK: Functions additional for actions
    private func handleAddNewUser(){
        self.user?.phoneNumber = phoneNumberTextField.text
        guard let uid = user?.uid,
            let name = user?.name,
            let email = user?.email,
            let password = user?.password,
            let phoneNumber = user?.phoneNumber,
            let isActive = user?.isActive,
            let userType = user?.userType?.rawValue else { return }
        let parameters = ["uid":uid,
                          "name":name,
                          "email":email,
                          "password":password,
                          "imageUrl": "",
                          "phoneNumber":phoneNumber,
                          "isActive": isActive,
                          "isShipper": userType] as [String : Any]
        Alamofire.request("https://wheel-ship.herokuapp.com/users/insert_new_user", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (data) in
            if let value = data.result.value as? [String: Any]{
                if let result = value["result"] as? Bool {
                    if result{
                        self.presentAlertWithTitleAndMessage(tile: "Thành công!", message: "Bạn đã đăng ký thành công", action: { (action) in
                            // save user and set user was logged
                            UserDefaults.standard.saveUser(user: self.user!)
                            UserDefaults.standard.setIsLoggedIn(value: true)
                            // redirect to root view
                            self.redirectToRootView()
                        })
                    }else{
                        let message = value["message"] as? String
                        self.presentAlertWithTitleAndMessage(title: "Lỗi", message: message!, completion: nil)
                    }
                }
            }
        }
    }
    
    private func redirectToRootView(){
        dismiss(animated: true, completion: nil)
        if let customTabbarViewController = UIApplication.shared.keyWindow?.rootViewController as? CustomTabbarController {
            if self.user?.userType == TypeOfUser.isOrderer {
                customTabbarViewController.loadViewControllersForOrderer()
            }else{
                customTabbarViewController.loadViewControllersForShipper()
            }
        }
    }
    
    private func handleUpdatePhoneNumber(phoneNumber:String, userId:String){
        Alamofire.request("https://wheel-ship.herokuapp.com/users/update_phone_number", method: .put, parameters: ["uid": userId, "phoneNumber": phoneNumber], encoding: URLEncoding.httpBody, headers: nil).responseJSON { (data) in
            if let value = data.result.value as? [String: Any] {
                if let result = value["result"] as? Bool {
                    if result {
                          // assign new phone number
                        self.userToEdit?.phoneNumber = phoneNumber
                         // and save to userDefault
                        UserDefaults.standard.saveUser(user: self.userToEdit!)
                        let alert = UIAlertController(title: "Sửa số điện thoại", message: "Bạn đã sửa số điện thoại thành công", preferredStyle: UIAlertControllerStyle.alert)
                        let cancelAction = UIAlertAction(title: "OK", style: .default) { (action) in
                            self.navigationController?.popViewController(animated: true)
                        }
                        alert.addAction(cancelAction)
                        self.present(alert, animated: true, completion: nil)
                    }else{
                        let message = value["message"] as? String
                        self.presentAlertWithTitleAndMessage(title: "Lỗi", message: message!)
                    }
                }
            }
        }
    }
    
}












