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
    var auth = Auth.instance // make instance of Auth RestApiManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup view
        setupGradientView()
        setupIconImageView()
        setupTitleTextView()
        setupPhoneNumberTextField()
        setupOKButton()
        
        // add tap gesture to return text field
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapReturn))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK : setup views
    
    func setupGradientView(){
        view.addSubview(gradientBackground)
        gradientBackground.frame = view.frame
    }
    
    func setupIconImageView(){
        view.addSubview(iconImageView)
        iconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        iconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        iconImageView.heightAnchor.constraint(equalToConstant: 130).isActive = true
        iconImageView.widthAnchor.constraint(equalToConstant: 130).isActive = true
    }
    
    func setupTitleTextView(){
        view.addSubview(titleTextView)
        titleTextView.anchorWithWidthHeightConstant(top: iconImageView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 12, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 120)
    }
    
    func setupPhoneNumberTextField(){
        view.addSubview(phoneNumberTextField)
        phoneNumberTextField.anchorWithWidthHeightConstant(top: titleTextView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 24, leftConstant: 25, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 50)
    }
    
    func setupOKButton(){
        view.addSubview(okButton)
        okButton.anchorWithWidthHeightConstant(top: phoneNumberTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 12, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 50)
    }
    
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
        return tf
    }()
    
    lazy var okButton:UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("OK", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3420125575)
        button.tintColor = UIColor.white
        button.addTarget(self ,action: #selector(handleRegisterAccount), for: .touchUpInside)
        return button
    }()
    
}
