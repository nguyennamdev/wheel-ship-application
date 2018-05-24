//
//  OrdererNotificationTableCell.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/23/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class OrdererNotificationTableViewCell : UITableViewCell {
    
    var ordererNotificationDelegate:OrdererNotificationDelegate?
    
    var order:Order? {
        didSet{
            guard let order = self.order, let notification = order.notification else {
                return
            }
            
            // assign value for views
            if notification.userImageUrl != ""{
                self.userImage.loadImageFromUrl(urlString: notification.userImageUrl!)
            }else{
                self.userImage.image = #imageLiteral(resourceName: "user2")
            }
            nameLabel.text = notification.name
            phoneNumberLabel.text = notification.phone
            contentLabel.setAttitudeString(title: ("\(Define.SHIPPER_REQUEST_STRING)\nMã đơn hàng:", UIColor.black), content: (order.orderId ?? "", UIColor.blue))
            stopTimeLabel.text = order.stopTime?.caculatingDatePassedWithCurrentDate()
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        setupUserImage()
        setupAgreeButton()
        setupDisagreeButton()
        setupNameLabel()
        setupPhoneLabel()
        setupContentLabel()
        setupStopTimeLabel()
    }
    
    // MARK: Setup views
    
    private func setupUserImage(){
        self.addSubview(userImage)
        userImage.anchorWithConstants(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 12, bottomConstant: 0, rightConstant: 0)
        userImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        userImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        userImage.layer.cornerRadius = 25
        userImage.clipsToBounds = true
    }
    
    private func setupAgreeButton(){
        self.addSubview(agreeButton)
        agreeButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -18).isActive = true
        agreeButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        agreeButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3, constant: -12).isActive = true
        agreeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    private func setupDisagreeButton(){
        self.addSubview(disagreeButton)
        disagreeButton.topAnchor.constraint(equalTo: agreeButton.bottomAnchor, constant:5).isActive = true
        disagreeButton.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -12).isActive = true
        disagreeButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.3, constant: -12).isActive = true
        disagreeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    private func setupNameLabel(){
        self.addSubview(nameLabel)
        nameLabel.anchorWithConstants(top: userImage.topAnchor, left: self.userImage.rightAnchor, bottom: nil, right: agreeButton.leftAnchor, topConstant: 8, leftConstant: 12, bottomConstant: 0, rightConstant: 12)
        nameLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
    }
    
    private func setupPhoneLabel(){
        self.addSubview(phoneNumberLabel)
        phoneNumberLabel.anchorWithConstants(top: nameLabel.bottomAnchor, left: userImage.rightAnchor, bottom: nil, right: agreeButton.leftAnchor, topConstant: 4, leftConstant: 12, bottomConstant: 0, rightConstant: 21)
        phoneNumberLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
    }
    
    private func setupContentLabel(){
        self.addSubview(self.contentLabel)
        contentLabel.anchorWithConstants(top: phoneNumberLabel.bottomAnchor, left: userImage.rightAnchor, bottom: nil, right: agreeButton.leftAnchor, topConstant: 4, leftConstant: 12, bottomConstant: 0, rightConstant: 12)
    }
    
    private func setupStopTimeLabel(){
        self.addSubview(self.stopTimeLabel)
        stopTimeLabel.anchorWithConstants(top: contentLabel.bottomAnchor, left: userImage.rightAnchor, bottom: self.bottomAnchor, right: agreeButton.leftAnchor, topConstant: 4, leftConstant: 12, bottomConstant: 4, rightConstant: 12)
    }
    
    // MARK: Actions
    @objc func handleResponseAgreeToShip(){
        guard let orderId = self.order?.orderId, let shipperId = self.order?.notification?.userId else {
            return
        }
        self.ordererNotificationDelegate?.responseToShip(orderId: orderId, shipperId: shipperId, isAgree: true)
    }
    
    @objc func handleResponseDisagreeToShip(){
        guard let orderId = self.order?.orderId, let shipperId = self.order?.notification?.userId else {
            return
        }
        self.ordererNotificationDelegate?.responseToShip(orderId: orderId, shipperId: shipperId, isAgree: false)
    }
    
    // MARK: Views
    
    let userImage:UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "user2")
        return image
    }()
    
    let nameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let phoneNumberLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.gray
        return label
    }()
    
    let contentLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()
    
    let stopTimeLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.gray
        return label
    }()
    
    lazy var agreeButton:UIButton = {
        let button = UIButton()
        button.setTitle("Đồng ý", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.layer.cornerRadius = 3
        button.clipsToBounds = true
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleResponseAgreeToShip), for: .touchUpInside)
        return button
    }()
    
    lazy var disagreeButton:UIButton = {
        let button = UIButton()
        button.setTitle("Từ chối", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.layer.cornerRadius = 3
        button.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleResponseDisagreeToShip), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

}
