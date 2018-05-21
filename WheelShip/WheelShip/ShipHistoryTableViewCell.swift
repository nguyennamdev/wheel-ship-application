//
//  ShipHistoryTableViewCell.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/21/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import Alamofire

class ShipHistoryViewCell: TableViewCell {
    
    var userId:String?
    var shipperDelegate:ShipperDelegate?
    
    var isHadAcceptButton:Bool? = false{
        didSet{
            if isHadAcceptButton!{
                acceptOrderButton.isHidden = false
                buttonsStackView.removeArrangedSubview(callButton)
                buttonsStackView.addArrangedSubview(acceptOrderButton)
            }else{
                buttonsStackView.removeArrangedSubview(acceptOrderButton)
                acceptOrderButton.isHidden = true
            }
            buttonsStackView.addArrangedSubview(callButton)
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        super.setupViews()
        setupDividerView()
        setupButtonsStackView()
    
        acceptOrderButton.addTarget(self, action: #selector(handleAcceptOrderToOrderer), for: .touchUpInside)
        callButton.addTarget(self, action: #selector(handleCall), for: .touchUpInside)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static func buttonForTitle(title:String, imageName:String) -> UIButton{
        let button = UIButton()
        button.setTitle(" \(title)", for: .normal)
        button.setImage(UIImage(named: imageName)?.resizeImage(newSize: CGSize(width: 22, height: 22)), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1), for: .normal)
        button.setTitleColor(UIColor.red, for: .highlighted)
        return button
    }
    
    // MARK: Actions
    @objc func handleAcceptOrderToOrderer(){
        guard let shipperId = self.userId,
            let orderId = self.order?.orderId
            else {
                return
        }
        Alamofire.request("http://localhost:3000/orders/accept_order", method: .put, parameters: ["orderId": orderId, "shipperId": shipperId], encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
            if let value = data.result.value as? [String: Any]{
                if let result = value["result"] as? String {
                    // if result is wait response, it will do not allow get this order
                    if result == "WaitResponse"{
                        self.shipperDelegate?.responseAcceptRequest(title: "Xin lỗi", message: "Đơn hàng này đã có người đặt trước rồi")
                    }else if result == "Wait"{
                        self.shipperDelegate?.responseAcceptRequest(title: "Thành công", message: "Bạn đã đặt được đơn hàng và chờ người đặt hàng phản hồi")
                        self.statusOrderLabel.setAttitudeString(title: (Define.STATUS, #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), content:(" \(Define.STATUS_WAIT_REPONSE)", #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)))
                    }else{
                        let message: String = value["message"] as! String
                        self.shipperDelegate?.responseAcceptRequest(title: "Lỗi", message: message)
                    }
                }
            }
        }
    }
    
    @objc func handleCall(){
        print("call")
    }
    
    // MARK: setup views
    
    func setupDividerView(){
        self.addSubview(dividerView)
        dividerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        dividerView.anchorWithConstants(top: self.noteLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 4, leftConstant: 12, bottomConstant: 0, rightConstant: 12)
        dividerView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    func setupButtonsStackView(){
        self.addSubview(buttonsStackView)
        buttonsStackView.anchorWithConstants(top: dividerView.bottomAnchor, left: self.leftAnchor, bottom: self.separatorView.topAnchor, right: self.rightAnchor)
    }
    
    
    // MARK: Views
    let acceptOrderButton:UIButton = ShipHistoryViewCell.buttonForTitle(title: "Nhận đơn", imageName: "send")
    let callButton:UIButton = ShipHistoryViewCell.buttonForTitle(title: "Gọi điện", imageName: "talking")
    
    let dividerView:UIView = UIView()
    
    let buttonsStackView:UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
}
