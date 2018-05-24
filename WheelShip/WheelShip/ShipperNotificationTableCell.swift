//
//  ShipperNotificationTableCell.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/23/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class ShipperNotificationTableViewCell : UITableViewCell {
    
    var order:Order?{
        didSet{
            guard let order = self.order, let notification = order.notification else {
                return
            }
            if notification.userImageUrl == "" {
                self.userImageView.image = #imageLiteral(resourceName: "user2")
            }else{
                self.userImageView.loadImageFromUrl(urlString: notification.userImageUrl!)
            }
            nameOrdererLabel.text = notification.name
            contentLabel.setAttitudeString(title: ("\(Define.SHIPPER_GET_RESPONSE_STRING)\nMã đơn hàng: ", UIColor.black), content: ("\(order.orderId!)", UIColor.black))
            stopTimeLabel.text = order.stopTime?.caculatingDatePassedWithCurrentDate()
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // setup views
    private func setupViews(){
        setupUserImageView()
        setupNameOrdererLabel()
        setupContentLabel()
        setupStopTimeLabel()
    }
    
    private func setupUserImageView(){
        self.addSubview(userImageView)
        userImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        userImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant:12).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        userImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupNameOrdererLabel(){
        self.addSubview(nameOrdererLabel)
        nameOrdererLabel.anchorWithConstants(top: self.topAnchor, left: userImageView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 12)
    }
    
    private func setupContentLabel(){
        self.addSubview(contentLabel)
        contentLabel.anchorWithConstants(top: nameOrdererLabel.bottomAnchor, left: userImageView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 4, leftConstant: 12, bottomConstant: 0, rightConstant: 21)
    }
    
    private func setupStopTimeLabel(){
        self.addSubview(stopTimeLabel)
        stopTimeLabel.anchorWithConstants(top: contentLabel.bottomAnchor, left: userImageView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 4, leftConstant: 12, bottomConstant: 0, rightConstant: 12)
    }
    
    let userImageView:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 25
        image.clipsToBounds = true
        return image
    }()
    

    let nameOrdererLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let contentLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let stopTimeLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.gray
        return label
    }()
    
}
