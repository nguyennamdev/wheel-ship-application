//
//  ShipHistoryTableViewCell+MethodApi.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/22/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Alamofire
import UIKit

extension ShipHistoryViewCell {
    
    func acceptOrder(orderId:String, shipperId:String){
        Alamofire.request("https://wheel-ship.herokuapp.com/orders/accept_order", method: .put, parameters: ["orderId": orderId, "shipperId": shipperId], encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
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
    
    func cancelOrder(orderId:String, shipperId:String){
        Alamofire.request("https://wheel-ship.herokuapp.com/orders/cancel_order", method: .put, parameters: ["orderId": orderId, "shipperId": shipperId], encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
            if let value = data.result.value as? [String: Any]{
                if let result = value["result"] as? String{
                    if result == "DontAllow"{
                        self.shipperDelegate?.presentResponseResult(title: "Xin lỗi", message: "Bạn không thể huỷ đơn này vì người đặt hàng đã chấp nhận cho bạn vẩn chuyển")
                    }else if result == "AllowCancel"{
                        self.shipperDelegate?.presentResponseResult(title: "Thành công", message: "Bạn đã huỷ thành công đơn hàng này")
                    }else{
                        let message:String = value["message"] as! String
                        self.shipperDelegate?.presentResponseResult(title: "Lỗi", message: message)
                    }
                }
            }
        }
    }
    
  
}

