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
    
    var isEnabledCancelButton:OrderStage?
    var isCompletedOrder:Bool?{
        didSet{
            if isCompletedOrder! == true{
                buttonsStackView.removeFromSuperview()
            }else{
                setupButtonsStackView()
            }
        }
    }

    var isHadAcceptButton:Bool? = false{
        didSet{
            if isHadAcceptButton!{
                customButtonsWithHaveAcceptButton()
            }else{
                customButtonsWithoutAcceptButton()
            }
        }
    }
 
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        super.setupViews()
        setupDividerView()
        setupButtonsStackView()
        
        acceptOrderButton.addTarget(self, action: #selector(handleAcceptOrderToOrderer), for: .touchUpInside)
        callButton.addTarget(self, action: #selector(handleShipperCall), for: .touchUpInside)
        cancelOrderButton.addTarget(self, action: #selector(handleCancelOrder), for: .touchUpInside)
        unsaveOrderButton.addTarget(self, action: #selector(handleUnsaveOrder), for: .touchUpInside)
        completeOrderButton.addTarget(self, action: #selector(handleCompleteOrder), for: .touchUpInside)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private funcs
    
    private func customButtonsWithHaveAcceptButton(){
        acceptOrderButton.isHidden = false
        cancelOrderButton.isHidden = true
        unsaveOrderButton.isHidden = false
        completeOrderButton.isHidden = true
        // remove sub view don't display
        buttonsStackView.removeArrangedSubview(cancelOrderButton)
        buttonsStackView.removeArrangedSubview(callButton)
        // add again buttons
        buttonsStackView.addArrangedSubview(acceptOrderButton)
        buttonsStackView.addArrangedSubview(callButton)
        buttonsStackView.addArrangedSubview(unsaveOrderButton)
    }
    
    private func customButtonsWithoutAcceptButton(){
        acceptOrderButton.isHidden = true
        cancelOrderButton.isHidden = false
        unsaveOrderButton.isHidden = true
        //
        buttonsStackView.removeArrangedSubview(acceptOrderButton)
        buttonsStackView.addArrangedSubview(callButton)
        
        if let enable = self.isEnabledCancelButton{
            if enable != OrderStage.hadShipper {
                completeOrderButton.isHidden = true
                buttonsStackView.addArrangedSubview(cancelOrderButton)
            }else{
                completeOrderButton.isHidden = false
                buttonsStackView.addArrangedSubview(completeOrderButton)
            }
        }
    }
    
    private static func buttonForTitle(title:String, imageName:String) -> UIButton{
        let button = UIButton()
        button.setTitle(" \(title)", for: .normal)
//        button.setImage(UIImage(named: imageName)?.resizeImage(newSize: CGSize(width: 22, height: 22)), for: .normal)
        button.setImage(UIImage(named: imageName), for: .normal)
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
        acceptOrder(orderId: orderId, shipperId: shipperId)
    }
    
    @objc func handleShipperCall(){
        guard let phoneOrderer = self.order?.phoneOrderer , let phoneRecever = self.order?.phoneReceiver else {
            return
        }
        self.shipperDelegate?.shipperCall!(phoneOrderer: phoneOrderer, phoneReceiver: phoneRecever)
    }
    
    @objc func handleCancelOrder(){
        guard let shipperId = self.userId,
            let orderId = self.order?.orderId
            else {
                return
        }
        cancelOrder(orderId: orderId, shipperId: shipperId)
    }
    
    @objc func handleUnsaveOrder(){
        guard let shipperId = self.userId,
            let orderId = self.order?.orderId
            else {
                return
        }
        self.shipperDelegate?.unsaveOrder!(orderId: orderId, userId: shipperId)
    }
    
    @objc func handleCompleteOrder(){
        guard let orderId = self.order?.orderId else {
            return
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request("https://wheel-ship.herokuapp.com/orders/shipper/completed_ship_order", method: .put, parameters: ["orderId": orderId], encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
             UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let value = data.result.value as? [String: Any]{
                if let result = value["result"] as? Bool{
                    if result{
                        self.shipperDelegate?.presentResponseResult(title: "Thành công", message: "Cảm ơn bạn đã vận chuyển hàng")
                    }
                }
            }
        }
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
    let dividerView:UIView = UIView()
    
    let buttonsStackView:UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        return stackView
    }()
    
    // buttons
    let acceptOrderButton:UIButton = ShipHistoryViewCell.buttonForTitle(title: "Nhận đơn", imageName: "send")
    let callButton:UIButton = ShipHistoryViewCell.buttonForTitle(title: "Gọi điện", imageName: "talking")
    let cancelOrderButton:UIButton = ShipHistoryViewCell.buttonForTitle(title: "Huỷ đơn", imageName: "cancel2")
    let unsaveOrderButton:UIButton = ShipHistoryViewCell.buttonForTitle(title: "Xoá", imageName: "delete")
    let completeOrderButton:UIButton = ShipHistoryViewCell.buttonForTitle(title: "Hoàn thành", imageName: "star")
    
    
}
