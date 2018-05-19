//
//  ChangePasswordViewController.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/17/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import Alamofire


class ChangePasswordViewController: UIViewController {

    @IBOutlet weak var backgroundView: GradientView!
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var changeButton: UIButton!
    
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.colors = [
            UIColor.rgb(r: 201, g: 214, b: 255).cgColor,
            UIColor.rgb(r: 226, g: 226, b: 226).cgColor
        ]
        
        oldPasswordTextField.delegate = self
        newPasswordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        changeButton.isEnabled = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Private functions
    private func updateStateChangeButton(){
        if oldPasswordTextField.text  == "" || newPasswordTextField.text == "" || confirmPasswordTextField.text == "" {
            changeButton.isEnabled = false
        }else{
            changeButton.isEnabled = true
            changeButton.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
            changeButton.setTitleColor(UIColor.white, for: .normal)
        }
    }

    
    // MARK: Actions
    @IBAction func close(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleChangePassword(_ sender: UIButton) {
        guard let old = oldPasswordTextField.text,
            let password = self.user?.password,
            let uid = self.user?.uid
        else {
            return
        }
        // check old password
        if old != password {
            oldPasswordTextField.text = "Mật khẩu không đúng"
            oldPasswordTextField.textColor = UIColor.red
            oldPasswordTextField.isSecureTextEntry = false
        }else{
            // require new password must match confirmPassword
            if confirmPasswordTextField.text != newPasswordTextField.text{
                confirmPasswordTextField.text = "Nhập lại mật khẩu sai"
                confirmPasswordTextField.textColor = UIColor.red
                confirmPasswordTextField.isSecureTextEntry = false
            }else{
                Alamofire.request("https://wheel-ship.herokuapp.com/users/update_password", method: .put, parameters: ["uid": uid, "password": newPasswordTextField.text!], encoding: URLEncoding.httpBody, headers: nil).responseJSON(completionHandler: { (data) in
                    if let value = data.result.value as? [String: Any] {
                        if let result = value["result"] as? Bool {
                            if result {
                                // assign new password
                                self.user?.password = password
                                UserDefaults.standard.saveUser(user: self.user!)
                                self.presentAlertWithTitleAndMessage(title: "Đồi mật khẩu thành công", message: "", completion: {
                                    self.dismiss(animated: true, completion: nil)
                                })
                            }
                        }
                    }
                })
            }
        }
    }
    
    // Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
// MARK: Implement UITextFieldDelegate
extension ChangePasswordViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateStateChangeButton()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = UIColor.black
        textField.isSecureTextEntry = true
    }
    
}




