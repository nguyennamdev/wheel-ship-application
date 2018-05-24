//
//  OrderNotificationViewController+CallApis.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/23/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Alamofire

extension OrdererNotificationViewController{
    
    func callApiToGetRequestsFromShipper(){
        guard let userId = self.user?.uid else {
            return
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request("\(Define.URL)/orders/orderer/list_order_wait_response", method: .get, parameters: ["userId": userId], encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if let value = data.result.value as? [String: Any]{
                if let result = value["result"] as? Bool{
                    if result{
                        // loop to get list order
                        if let orderDictionaries = value["data"] as? [NSDictionary]{
                            self.arrOrder.removeAll()
                            for dict in orderDictionaries{
                                let order = Order()
                                order.setValueByNSDictionary(dictionary: dict)
                                let notification = Notification()
                                notification.setValueWithDictionary(dictionary: dict)
                                order.notification = notification
                                // append to array order
                                self.arrOrder.append(order)
                            }
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
        
    }
    
    func getNumberOfNotificationForOrderer(ordererId:String, response:@escaping (Int) -> Void){
        Alamofire.request("\(Define.URL)/orders/orderer/count_order_wait_response", method: .get, parameters: ["userId": ordererId], encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
            if let value = data.result.value as? NSDictionary{
                if let size = value.value(forKey: "size") as? Int{
                    if size != 0{
                        if let resultData = value.value(forKey: "data") as? [[String: Any]]{
                            if let numberOfNotifications = resultData.first!["size"] as? Int{
                                response(numberOfNotifications)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func ordererAgreeShipperToShip(orderId:String, shipperId:String){
        actionOrdererToShip(urlString: "\(Define.URL)/orders/orderer/agree_to_ship", orderId: orderId, shipperId: shipperId)
    }
    
    func ordererDisAgreeShipperToShip(orderId:String, shiperId:String){
        actionOrdererToShip(urlString: "\(Define.URL)/orders/orderer/disagree_to_ship", orderId: orderId, shipperId: shiperId)
       
    }
    
    
    
    private func actionOrdererToShip(urlString:String, orderId:String, shipperId:String){
        Alamofire.request(urlString, method: .put, parameters: ["orderId": orderId, "shipperId": shipperId], encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
            if let value = data.result.value as? [String: Any]{
                if let result = value["result"] as? Bool{
                    if result{
                        self.presentAlertWithTitleAndMessage(title: "Phản hồi", message: "Phản hồi của bạn đã được gửi tới shipper", action: nil)
                        self.callApiToGetRequestsFromShipper()
                    }else{
                        let message:String = value["message"] as! String
                        self.presentAlertWithTitleAndMessage(title: "Lỗi", message: message, action: nil)
                    }
                }
            }
        }
    }
    

}
