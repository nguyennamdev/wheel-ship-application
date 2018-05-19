//
//  PopupEntryPhoneNumber.swift
//  WheelShip
//
//  Created by Nguyen Nam on 2/5/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class PopupEntryPhoneNumber:UIViewController {
    
    var user:User?
    var auth = Authentication.instance // make instance of Auth RestApiManager
    var userToEdit:User?{
        didSet{
            guard let phoneNumber = userToEdit?.phoneNumber else {
                return
            }
            self.phoneNumberTextField.text = phoneNumber
        }
    }
    
    var addNewAccount: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup view
        setupGradientView()
        setupBackButton()
        setupIconImageView()
        setupTitleTextView()
        setupPhoneNumberTextField()
        setupOKButton()
        
        // add tap gesture to return text field
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapReturn))
        view.addGestureRecognizer(tapGesture)
        
        self.phoneNumberTextField.delegate = self
    }
    
    // MARK: Views

    let gradientBackground:GradientView = {
        let gv = GradientView()
        gv.translatesAutoresizingMaskIntoConstraints = false
        gv.layer.cornerRadius = 5
        gv.clipsToBounds = true
        gv.colors = [
            UIColor.rgb(r: 53, g: 92, b: 125).cgColor,
            UIColor.rgb(r: 108, g: 91, b: 123).cgColor,
            UIColor.rgb(r: 192, g: 108, b: 132).cgColor
        ]
        return gv
    }()
    
    let iconImageView:UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "question"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let titleTextView:UITextView = {
        let tv = UITextView()
        let attribute = NSMutableAttributedString(string: "Số điện thoại để liên hệ với bạn\n\n", attributes:[NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 20),NSAttributedStringKey.foregroundColor:UIColor.white ])
        attribute.append(NSAttributedString(string: "Mọi người có thể nhìn được số điện thoại của bạn. Số điện thoại của bạn giúp mọi người liên hệ với bạn.", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: UIColor.white]))
        tv.attributedText = attribute
        tv.isEditable = false
        tv.textAlignment = .center
        tv.isSelectable = false
        tv.backgroundColor = UIColor.clear
        return tv
    }()
    
    let phoneNumberTextField:UITextField = {
        let tf = UITextField()
        tf.setupDefault()
        tf.setupImageForLeftView(image: #imageLiteral(resourceName: "telephone"))
        tf.placeholder = "Nhập số điện thoại"
        tf.keyboardType = .numberPad
        tf.clearsOnBeginEditing = true
        return tf
    }()
    
    lazy var okButton:UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("OK", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3420125575)
        button.tintColor = UIColor.white
        button.addTarget(self ,action: #selector(handleUserPhoneNumber), for: .touchUpInside)
        return button
    }()
    
    
    lazy var backButton:UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setImage(#imageLiteral(resourceName: "close"), for: .normal)
        button.tintColor = UIColor.white
        button.addTarget(self, action: #selector(backToPreviousController), for: .touchUpInside)
        return button
    }()
}

// MARK: Implement UITextFieldDelegate
extension PopupEntryPhoneNumber : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.textColor = UIColor.black
    }
    
}


