//
//  EditUserNameViewController.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/17/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import Alamofire

class EditUserNameViewController: UIViewController {
    
    var user:User?{
        didSet{
            if let name = user?.name {
                self.userNameTextField.text = name
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        // custom navigationbar
        self.navigationItem.title = "Tên người dùng"
        // init bar buttons
        let cancelButton = UIBarButtonItem(title: "Huỷ", style: .plain, target: self, action: #selector(cancelEditUserName))
        let editButton = UIBarButtonItem(title: "Lưu", style: .plain, target: self, action: #selector(handleEditUserName))
        
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = editButton
        
        setupViews()
        
    }
    
    // MARK: Setup views
    
    private func setupViews(){
        setupTitleLabel()
        setupUserNameTextField()
    }
    
    private func setupTitleLabel(){
        view.addSubview(titleLabel)
        titleLabel.anchorWithConstants(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 24)
    }
    private func setupUserNameTextField(){
        self.view.addSubview(userNameTextField)
        userNameTextField.anchorWithConstants(top: titleLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 8)
        userNameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        userNameTextField.delegate = self
    }
    
    // MARK: Actions
    @objc private func cancelEditUserName(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func handleEditUserName(){
        if userNameTextField.text == "" {
            titleLabel.text = "Bạn phải nhập tên nếu muốn thay đổi"
        }else{
            guard let userId = self.user?.uid,
                let userName = self.userNameTextField.text  else { return }
            Alamofire.request("https://wheel-ship.herokuapp.com/users/update_user_name", method: .put, parameters: ["uid": userId, "name": userName], encoding: URLEncoding.httpBody, headers: nil).responseJSON(completionHandler: { (data) in
                if let value = data.result.value as? [String: Any] {
                    if let result = value["result"] as? Bool {
                        if result {
                            // assign new user name number
                            self.user?.name = userName
                            // save by NSUserDefault
                            UserDefaults.standard.saveUser(user: self.user!)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            })
        }
    }
    
    // MARK: Views
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.text = "Nhâp tên người dùng"
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let userNameTextField:UITextField = {
       let tf = UITextField()
       tf.layer.borderWidth = 1
       tf.layer.borderColor = UIColor.gray.cgColor
       return tf
    }()

}

// MARK: Implement UITextFieldDelegate
extension EditUserNameViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        titleLabel.text = "Nhâp tên người dùng"
    }
    
}

