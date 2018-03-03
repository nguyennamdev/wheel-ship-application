//
//  PopupEntryPhoneNumber+Extension.swift
//  WheelShip
//
//  Created by Nguyen Nam on 2/5/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

extension PopupEntryPhoneNumber {
        
    @objc func handleTapReturn(){
        view.endEditing(true)
    }
    
    @objc func handleRegisterAccount(){
        guard let phoneNumber = phoneNumberTextField.text else { return }
        self.user?.phoneNumber = phoneNumber
        guard let uid = user?.uid,
            let name = user?.name,
            let email = user?.email,
            let password = user?.password else { return }
        let values = ["uid":uid, "name":name, "email":email, "password":password, "phoneNumber":phoneNumber]
        auth.insertNewUser(value: values) { (data) in
            print(data)
        }
    }
    
}
