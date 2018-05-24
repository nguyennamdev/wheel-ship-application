//
//  ViewController.swift
//  WheelShip
//
//  Created by Nguyen Nam on 1/26/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import Alamofire

class LoginViewController: UIViewController {
 
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup views
        setupGradientView()
        setupLogoLabel()
        setupActivityIndicatorView()
        setupEmailTextField()
        setupPasswordTextField()
        setupLogginButton()
        setupLabel()
        setupRegisterButton()
        setupQuestionLabel()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    // MARK: Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: Private func
    private func callApiToLogin(email: String, password: String){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        self.activityIndicatorView.startAnimating()
        let parameter = ["logEmail": email, "logPassword": password] as Parameters
        Alamofire.request("\(Define.URL)/users/login", method: .post, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON(completionHandler: { (data) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.activityIndicatorView.stopAnimating()
            if let value = data.result.value as? NSDictionary {
                if let result = value.value(forKey: "result") as? Bool{
                    if result{
                        if let userDictionary = value.value(forKey: "data") as? NSDictionary{
                            self.parseJsonDataToUser(data: userDictionary)
                            UserDefaults.standard.saveUser(user: self.user!)
                            self.handleUserType(user: self.user!)
                            // save user logged
                            UserDefaults.standard.setIsLoggedIn(value: true)
                            // dismiss
                            self.dismiss(animated: true, completion: nil)
                        }
                    }else{
                        let message = value.value(forKey: "message") as? String
                        self.presentAlertWithTitleAndMessage(title: "Lỗi", message: message ?? "")
                    }
                }
            }
        })
    }
    
    private func parseJsonDataToUser(data:NSDictionary){
        self.user = User()
        user?.setValueWithDictionary(dictionary: data)
    }
    
    private func handleUserType(user:User){
        // if user is orderer, tabbar will set view controllers other user is shipper
        // get root view to set new view controllers
        if let customTabbar = UIApplication.shared.keyWindow?.rootViewController as? CustomTabbarController{
            if user.userType == TypeOfUser.isOrderer {
                customTabbar.loadViewControllersForOrderer(user: user)
            }else if user.userType == TypeOfUser.isShipper{
                customTabbar.loadViewControllersForShipper(user: user)
            }
        }
    }
    
    // MARK : Views
    let logoLabel:UILabel = {
        let label = UILabel()
        label.text = "Wheel Ship"
        label.textColor = UIColor.white
        label.font = UIFont(name: "Noteworthy", size:58)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let gradientView:GradientView = {
        let gradientView = GradientView()
        gradientView.colors = [
            UIColor.rgb(r: 53, g: 92, b: 125).cgColor,
            UIColor.rgb(r: 108, g: 91, b: 123).cgColor,
            UIColor.rgb(r: 192, g: 108, b: 132).cgColor
        ]
        return gradientView
    }()
    
    let emailTextField:UITextField = {
        let textField = UITextField()
        textField.setupDefault()
        textField.placeholder = "Email Address"
        // custom left view
        textField.setupImageForLeftView(image:#imageLiteral(resourceName: "mail2"))
        textField.tintColor = UIColor.black
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.clearsOnBeginEditing = true
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let passwordTextField:UITextField = {
        let textField = UITextField()
        textField.setupDefault()
        textField.isSecureTextEntry = true
        textField.placeholder = "Password"
        textField.tintColor = UIColor.black
        // custom left view
        textField.setupImageForLeftView(image: #imageLiteral(resourceName: "lock2"))
//        textField.clea
        return textField
    }()
    
    lazy var loginButton:UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.backgroundColor = UIColor.clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        button.tintColor = UIColor.white
        button.setTitle("ĐĂNG NHẬP", for: .normal)
        button.addTarget(self, action: #selector(handleLoginUser), for: .touchUpInside)
        return button
    }()
    
    let dummyLabel:UILabel = {
        let label = UILabel()
        label.text = "- Hoặc -"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textColor = UIColor.white
        label.textAlignment = .center
        return label
    }()
    
    let activityIndicatorView:UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        activity.stopAnimating()
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()
    
    let questionLabel:UILabel = {
        let label = UILabel()
        label.text = "Không có tài khoản?"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    
    lazy var registerButton:UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Đăng ký", for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(showRegisterController), for: .touchUpInside)
        return button
    }()    
}

// MARK: Actions
extension LoginViewController {
    
    @objc fileprivate func showRegisterController(){
        let registerController = RegisterController()
        present(registerController, animated: true, completion: nil)
    }
    
    @objc fileprivate func handleLoginUser(){
        if emailTextField.text == ""{
            emailTextField.text = "Bạn chưa nhập email"
            emailTextField.textColor = UIColor.red
        }else if passwordTextField.text == "" {
            passwordTextField.isSecureTextEntry = false
            passwordTextField.text = "Bạn chưa nhập password"
            passwordTextField.textColor = UIColor.red
        }else{
            if emailTextField.checkTextIsEmail(){
              // invoke func call api to login
              callApiToLogin(email: emailTextField.text!, password: passwordTextField.text!)
            }else{
                emailTextField.text = "Email sai định dạng"
                emailTextField.textColor = UIColor.red
            }
        }
    }
}

// MARK: TextFieldDelegate

extension LoginViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        textField.textColor = UIColor.black
        if textField.isEqual(passwordTextField){
            textField.isSecureTextEntry = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.isEqual(emailTextField){
            emailTextField.text = textField.text?.lowercased()
        }
    }
    
}








