//
//  LoginController+setupViews.swift
//  WheelShip
//
//  Created by Nguyen Nam on 3/5/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit


extension LoginViewController {
    // MARK : setup view functions
    
    func setupGradientView(){
        view.addSubview(gradientView)
        gradientView.anchorWithConstants(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
    }
    
    func setupLogoLabel(){
        view.addSubview(logoLabel)
        logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoLabel.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3, constant:-40).isActive = true
        logoLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:12).isActive = true
    }
    
    func setupActivityIndicatorView(){
        view.addSubview(activityIndicatorView)
        activityIndicatorView.topAnchor.constraint(equalTo: logoLabel.bottomAnchor).isActive = true
        activityIndicatorView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setupEmailTextField(){
        view.addSubview(emailTextField)
        // x,y,w,h
        emailTextField.topAnchor.constraint(equalTo: activityIndicatorView.bottomAnchor, constant: 12).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24).isActive = true
        emailTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24).isActive = true
    }
    
    func setupPasswordTextField(){
        view.addSubview(passwordTextField)
        // x,y,w,h
        passwordTextField.anchorWithWidthHeightConstant(top: emailTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 12, leftConstant:24, bottomConstant: 0, rightConstant:24, widthConstant: 0, heightConstant: 50)
    }
    
    func setupLogginButton(){
        view.addSubview(loginButton)
        // x,y,w,h
        loginButton.anchorWithWidthHeightConstant(top: passwordTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 55)
    }
    
    func setupLabel(){
        view.addSubview(dummyLabel)
        dummyLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20).isActive = true
        dummyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func setupRegisterButton(){
        view.addSubview(registerButton)
        registerButton.anchorWithConstants(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 20, rightConstant: 0)
        registerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        registerButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func setupQuestionLabel(){
        view.addSubview(questionLabel)
        questionLabel.bottomAnchor.constraint(equalTo: registerButton.topAnchor).isActive = true
        questionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    
}
