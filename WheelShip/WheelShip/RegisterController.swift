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
    
    weak var user:User?
    
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
        tf.setupImageForLeftView(image: #imageLiteral(resourceName: "user"))
        return tf
    }()
    
    let emailTextField:UITextField = {
        let tf = UITextField()
        tf.setupDefault()
        tf.placeholder = " Địa chỉ email"
        tf.keyboardType = .emailAddress
        tf.setupImageForLeftView(image: #imageLiteral(resourceName: "mail"))
        return tf
    }()
    
    let passwordTextField:UITextField = {
        let tf = UITextField()
        tf.setupDefault()
        tf.placeholder = " Mật khẩu"
        tf.isSecureTextEntry = true
        tf.setupImageForLeftView(image: #imageLiteral(resourceName: "lock"))
        return tf
    }()
    
    let repasswordTextField:UITextField = {
        let tf = UITextField()
        tf.setupDefault()
        tf.placeholder = " Nhập lại mật khẩu"
        tf.isSecureTextEntry = true
        tf.setupImageForLeftView(image: #imageLiteral(resourceName: "lock"))
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
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            // init user and set value for property
            user = User(context: managedContext)
            user?.uid =  String().randomString()
            user?.name = nameTextField.text!
            user?.email = emailTextField.text!
            user?.password = passwordTextField.text!
            user?.isActive = UserState.isActive.rawValue
            user?.isShipper = TypeOfUser.isOrderer.rawValue // is orderer
            
            // show popup
            let popupEntryPhoneNumber = PopupEntryPhoneNumber()
            popupEntryPhoneNumber.user = self.user
            self.present(popupEntryPhoneNumber, animated: true, completion: nil)
        }else{
            print("false")
        }
    }
    
}

// implement functions of text field delegate
extension RegisterController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == repasswordTextField {
            if repasswordTextField.text != passwordTextField.text{
                repasswordTextField.text = "Nhập lại mật khẩu sai"
                repasswordTextField.isSecureTextEntry = false
                repasswordTextField.textColor = UIColor.red
                repasswordTextField.font = UIFont.systemFont(ofSize: 13)
            }
        }else if textField == emailTextField{
            let pattern = "^([^0-9]\\w*)@gmail(\\.com(\\.vn)?)$"
            let predicate = NSPredicate(format: "self MATCHES [c] %@", pattern)
            if !predicate.evaluate(with: textField.text){
                emailTextField.text = "Sai định dạng, vd: example@gmail.com"
                emailTextField.textColor = UIColor.red
                emailTextField.font = UIFont.systemFont(ofSize: 13)
            }
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == repasswordTextField {
            repasswordTextField.text = nil
            repasswordTextField.isSecureTextEntry = true
            repasswordTextField.textColor = UIColor.white
            repasswordTextField.font = UIFont.systemFont(ofSize: 16)
        }else if textField == emailTextField{
            emailTextField.text = nil
            emailTextField.textColor = UIColor.white
            emailTextField.font = UIFont.systemFont(ofSize: 16)
        }
    }
}








