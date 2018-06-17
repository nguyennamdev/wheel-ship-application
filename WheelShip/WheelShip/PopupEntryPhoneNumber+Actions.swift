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
                    if !reachbility.currentReachbilityStatus(){
                        present(reachbility.showAlertToSettingInternet(), animated: true, completion: {
                            if self.reachbility.currentReachbilityStatus() {
                                self.handleUpdatePhoneNumber(phoneNumber: phoneNumber, userId: userId)
                            }
                        })
                    }else{
                        handleUpdatePhoneNumber(phoneNumber: phoneNumber, userId: userId)
                    }
                }
            }else{
                // to create new user
                if !reachbility.currentReachbilityStatus(){
                    present(reachbility.showAlertToSettingInternet(), animated: true, completion: {
                        if self.reachbility.currentReachbilityStatus() {
                            self.handleAddNewUser()
                        }
                    })
                }else{
                     handleAddNewUser()
                }
            }
        }else{
            phoneNumberTextField.text = "Số điện thoại sai định dạng"
            phoneNumberTextField.textColor = UIColor.red
        }
    }
    
    @objc func backToPreviousController(){
        dismiss(animated: true, completion: nil)
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
        Alamofire.request("\(Define.URL)/users/insert_new_user", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (data) in
            if let value = data.result.value as? [String: Any]{
                if let result = value["result"] as? Bool {
                    if result{
                        self.presentAlertWithTitleAndMessage(title: "Thành công!", message: "Bạn đã đăng ký thành công", action: { (action) in
                            self.dismiss(animated: true, completion: nil)
                            self.addNewAccount!(true)
                        })
                    }else{
                        let message = value["message"] as? String
                        self.presentAlertWithTitleAndMessage(title: "Lỗi", message: message!, completion: nil)
                    }
                }
            }
        }
    }
    
    private func handleUpdatePhoneNumber(phoneNumber:String, userId:String){
        Alamofire.request("\(Define.URL)/users/update_phone_number", method: .put, parameters: ["uid": userId, "phoneNumber": phoneNumber], encoding: URLEncoding.httpBody, headers: nil).responseJSON { (data) in
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












