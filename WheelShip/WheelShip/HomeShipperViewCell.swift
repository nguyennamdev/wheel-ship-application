//
//  HomeShipperViewCell.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/20/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import Alamofire

class HomeShipperViewCell: BaseTableViewCell {
    
    var isSave:Bool? = false{
        didSet{
            if isSave!{
                self.saveButton.setTitleColor(UIColor.blue, for: .normal)
                self.saveButton.setTitle(" Đã lưu", for: .normal)
            }else{
                self.saveButton.setTitleColor(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1), for: .normal)
                self.saveButton.setTitle(" Lưu lại", for: .normal)
            }
        }
    }
    var userId:String?
    var shipperDelegate:ShipperDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        setupViews()
        setupDividerView()
        setupButtonsStackView()

        acceptOrderButton.addTarget(self, action: #selector(handleAcceptOrderToOrderer), for: .touchUpInside)
        callButton.addTarget(self, action: #selector(handleCallToOrderer), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(handleSaveOrder), for: .touchUpInside)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Actions
    @objc private func handleAcceptOrderToOrderer(){
        guard let shipperId = self.userId,
            let orderId = self.order?.orderId
            else {
                return
        }
         UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request("\(Define.URL)/orders/shipper/accept_order", method: .put, parameters: ["orderId": orderId, "shipperId": shipperId], encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
             UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let value = data.result.value as? [String: Any]{
                if let result = value["result"] as? String {
                    // if result is wait response, it will do not allow get this order
                    if result == "WaitResponse"{
                        self.shipperDelegate?.presentResponseResult(title: "Xin lỗi", message: "Đơn hàng này đã có người đặt trước rồi")
                    }else if result == "Wait"{
                        self.shipperDelegate?.presentResponseResult(title: "Thành công", message: "Bạn đã đặt được đơn hàng và chờ người đặt hàng phản hồi")
                        self.statusOrderLabel.setAttitudeString(title: (Define.STATUS, #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), content:(" \(Define.STATUS_WAIT_REPONSE)", #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)))
                    }else{
                        let message: String = value["message"] as! String
                        self.shipperDelegate?.presentResponseResult(title: "Lỗi", message: message)
                    }
                }
            }
        }
    }
    
    @objc private func handleCallToOrderer(){
        guard let phoneOrderer = self.order?.phoneOrderer else {
            return
        }
        if let url = URL(string: "tel://\(phoneOrderer)"),
            UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc private func handleSaveOrder(){
        if isSave! {
            return
        }
        guard let userId = self.userId,
            let orderId = self.order?.orderId
            else { return }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request("\(Define.URL)/users/save_order", method: .put, parameters:[ "uid": userId, "orderId": orderId], encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
            if let value = data.result.value as? [String: Any]{
                if let result = value["result"] as? Bool{
                    if result{
                        self.isSave = true
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    }
                }
            }
        }
    }
    
    func setupDividerView(){
        self.addSubview(dividerView)
        dividerView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        dividerView.anchorWithConstants(top: self.noteLabel.bottomAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, topConstant: 4, leftConstant: 12, bottomConstant: 0, rightConstant: 12)
        dividerView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }

    func setupButtonsStackView(){
        self.addSubview(buttonsStackView)
        buttonsStackView.anchorWithConstants(top: dividerView.bottomAnchor, left: self.leftAnchor, bottom: self.separatorView.topAnchor, right: self.rightAnchor)
        buttonsStackView.addArrangedSubview(acceptOrderButton)
        buttonsStackView.addArrangedSubview(callButton)
        buttonsStackView.addArrangedSubview(saveButton)
    }
    
    private static func buttonForTitle(title:String, imageName:String) -> UIButton{
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        button.setTitle(" \(title)", for: .normal)
//        button.setImage(UIImage(named: imageName)?.resizeImage(newSize: CGSize(width: 18, height: 18)), for: .normal)
        button.setImage(UIImage(named: imageName), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1), for: .normal)
        button.setTitleColor(UIColor.red, for: .highlighted)
        return button
    }
    
    
    // MARK: Views
    let acceptOrderButton:UIButton = HomeShipperViewCell.buttonForTitle(title: "Nhận đơn", imageName: "send")
    let callButton:UIButton = HomeShipperViewCell.buttonForTitle(title: "Gọi điện", imageName: "talking")
    let saveButton:UIButton = HomeShipperViewCell.buttonForTitle(title: "Lưu lại", imageName: "save")
    
    let dividerView:UIView = UIView()
    
    let buttonsStackView:UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    
}
