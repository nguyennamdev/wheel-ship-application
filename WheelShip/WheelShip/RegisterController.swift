//
//  RegisterController.swift
//  WheelShip
//
//  Created by Nguyen Nam on 1/30/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import CoreData

class RegisterController:UIViewController {
    
   var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup views
        setupBackgroundView()
        setupLogoLabel()
        setupBackButton()
        setupATextField(newView: nameTextField, bottomOf: titleLabel)
        setupATextField(newView: emailTextField, bottomOf: nameTextField)
        setupATextField(newView: passwordTextField, bottomOf: emailTextField)
        setupATextField(newView: repasswordTextField, bottomOf: passwordTextField)
        setupRegisterButton()
        
    }
    

    func checkDataUserEntryed() -> Bool{
        switch ("") {
        case nameTextField.text!, emailTextField.text!, passwordTextField.text!, repasswordTextField.text!:
            return false
        default:
            break
        }
        return true
    }
    
    // MARK : Views
    let backgroundGradientView:GradientView = {
        let gradientView = GradientView()
        gradientView.colors = [
            UIColor.rgb(r: 53, g: 92, b: 125).cgColor,
            UIColor.rgb(r: 108, g: 91, b: 123).cgColor,
            UIColor.rgb(r: 192, g: 108, b: 132).cgColor
        ]
        return gradientView
    }()
    
    lazy var backButton:UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(closeView), for: .touchUpInside)
        return button
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "Tạo tài khoản"
        label.textColor = UIColor.white
        label.font = UIFont(name: "Noteworthy", size:52)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    let nameTextField:UITextField = {
        let tf = UITextField()
        tf.setupDefault()
        tf.placeholder = " Họ tên"
        // custom left view
        tf.setupImageForLeftView(image: #imageLiteral(resourceName: "avatar"))
        return tf
    }()
    
    let emailTextField:UITextField = {
        let tf = UITextField()
        tf.setupDefault()
        tf.textColor = UIColor.black
        tf.placeholder = " Địa chỉ email"
        tf.keyboardType = .emailAddress
        tf.setupImageForLeftView(image:#imageLiteral(resourceName: "mail2"))
        return tf
    }()
    
    let passwordTextField:UITextField = {
        let tf = UITextField()
        tf.setupDefault()
        tf.placeholder = " Mật khẩu"
        tf.isSecureTextEntry = true
        tf.setupImageForLeftView(image: #imageLiteral(resourceName: "lock2"))
        return tf
    }()
    
    let repasswordTextField:UITextField = {
        let tf = UITextField()
        tf.setupDefault()
        tf.placeholder = " Nhập lại mật khẩu"
        tf.isSecureTextEntry = true
        tf.setupImageForLeftView(image: #imageLiteral(resourceName: "lock2"))
        return tf
    }()
    
    let continueButton:UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.backgroundColor = UIColor.clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        button.tintColor = UIColor.white
        button.setTitle("Tiếp tục", for: .normal)
        button.addTarget(self, action: #selector(handleShowPopupEntryPhoneNumer), for: .touchUpInside)
        return button
    }()
    
}

// Actions
extension RegisterController {
    
    @objc func closeView(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleShowPopupEntryPhoneNumer(){
        if checkDataUserEntryed() {
            if !emailTextField.checkTextIsEmail(){
                emailTextField.text = "Sai định dạng, vd: example@gmail.com"
                emailTextField.textColor = UIColor.red
            }else{ // check text repasswordTextField matches passwordTextField
                if repasswordTextField.text != passwordTextField.text {
                    repasswordTextField.text = "Nhập lại mật khẩu sai"
                    repasswordTextField.isSecureTextEntry = false
                    repasswordTextField.textColor = UIColor.red
                }else{
                    let uid = String().randomString()
                    
                    guard let name = nameTextField.text,
                        let email = emailTextField.text,
                        let password = passwordTextField.text else { return }
                    
                    // init user and set value for property
                    self.user = User(uid: uid, name: name, email: email, password: password, imageUrl: "", phoneNumber: nil, isActive: UserState.isActive.rawValue, userType: TypeOfUser.isOrderer)
                    // show popup
                    let popupEntryPhoneNumber = PopupEntryPhoneNumber()
                    popupEntryPhoneNumber.user = self.user
                    self.present(popupEntryPhoneNumber, animated: true, completion: nil)
                }
            }
        }else{
            presentAlertWithTitleAndMessage(title: "Vui lòng", message: "Bạn hãy nhập đầy đủ thông tin trên!")
        }
    }
    
}

// implement functions of text field delegate
extension RegisterController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
 
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = UIColor.black
        textField.text = ""
        if textField.isEqual(passwordTextField) || textField.isEqual(repasswordTextField){
            textField.isSecureTextEntry = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.isEqual(emailTextField){
            textField.text = textField.text?.lowercased()
        }
    }
}








