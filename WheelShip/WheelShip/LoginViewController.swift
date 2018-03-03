//
//  ViewController.swift
//  WheelShip
//
//  Created by Nguyen Nam on 1/26/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup views
        setupGradientView()
        setupLogoLabel()
        setupEmailTextField()
        setupPasswordTextField()
        setupLogginButton()
        setupLabel()
        setupRegisterButton()
        setupQuestionLabel()
        
    }
    
    // MARK : setup view functions
    
    private func setupGradientView(){
        view.addSubview(gradientView)
        gradientView.anchorWithConstants(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    private func setupLogoLabel(){
        view.addSubview(logoLabel)
        logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        logoLabel.topAnchor.constraint(equalTo: view.topAnchor, constant:12).isActive = true
    }
    
    private func setupEmailTextField(){
        view.addSubview(emailTextField)
        // x,y,w,h
        emailTextField.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: 12).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
    }
    
    private func setupPasswordTextField(){
        view.addSubview(passwordTextField)
        // x,y,w,h
        passwordTextField.anchorWithWidthHeightConstant(top: emailTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 12, leftConstant:24, bottomConstant: 0, rightConstant:24, widthConstant: 0, heightConstant: 50)
    }
    
    private func setupLogginButton(){
        view.addSubview(loginButton)
        // x,y,w,h
        loginButton.anchorWithWidthHeightConstant(top: passwordTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 55)
    }
    
    private func setupLabel(){
        view.addSubview(dummyLabel)
        dummyLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20).isActive = true
        dummyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
   
    private func setupRegisterButton(){
        view.addSubview(registerButton)
        registerButton.anchorWithConstants(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 20, rightConstant: 0)
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    private func setupQuestionLabel(){
        view.addSubview(questionLabel)
        questionLabel.bottomAnchor.constraint(equalTo: registerButton.topAnchor).isActive = true
        questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    // MARK : Views
    let logoLabel:UILabel = {
        let label = UILabel()
        label.text = "Wheel Ship"
        label.textColor = UIColor.white
        label.font = UIFont(name: "Noteworthy", size:52)
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
        textField.setupImageForLeftView(image:#imageLiteral(resourceName: "mail"))
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let passwordTextField:UITextField = {
        let textField = UITextField()
        textField.setupDefault()
        textField.isSecureTextEntry = true
        textField.placeholder = "Password"
        // custom left view
        textField.setupImageForLeftView(image: #imageLiteral(resourceName: "lock"))
        return textField
    }()
    
    let loginButton:UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.backgroundColor = UIColor.clear
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        button.tintColor = UIColor.white
        button.setTitle("ĐĂNG NHẬP", for: .normal)
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

// actions
extension LoginViewController {
    
    @objc fileprivate func showRegisterController(){
        let registerController = RegisterController()
        present(registerController, animated: true, completion: nil)
    }
    
}










