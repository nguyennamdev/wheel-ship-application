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
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    // MARK: Touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
        textField.setupImageForLeftView(image:#imageLiteral(resourceName: "mail2"))
        textField.tintColor = UIColor.black
        textField.translatesAutoresizingMaskIntoConstraints = false
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

// MARK: TextFieldDelegate

extension LoginViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}








