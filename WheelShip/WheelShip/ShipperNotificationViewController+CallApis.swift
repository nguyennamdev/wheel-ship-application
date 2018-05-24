//
//  ShipperNotificationViewController+CallApis.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/23/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import Alamofire

extension ShipperNotificationViewController {
    
    public func getListOrderAgreed(){
        if let shipperId = self.user?.uid {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            Alamofire.request("\(Define.URL)/orders/shipper/list_oder_agreed", method: .get, parameters: ["shipperId": shipperId], encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (data) in
                if let value = data.result.value as? NSDictionary {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    if let result = value.value(forKey: "result") as? Bool {
                        if result{
                            if let orderDictionaries = value.value(forKey: "data") as? [NSDictionary]{
                                // remove all old order in arr order
                                self.arrOrder.removeAll()
                                // loop in orderDictionaries to get array order
                                for dict in orderDictionaries{
                                    let order = Order()
                                    order.setValueByNSDictionary(dictionary: dict)
                                    let notification = Notification()
                                    notification.setValueWithDictionary(dictionary: dict)
                                    order.notification = notification
                                    // append new order
                                    self.arrOrder.append(order)
                                }
                                self.tableView.reloadData()
                            }
                        }
                    }
                }
            })
        }
    }
    
    func getNumberNotification(shipperId:String, response: @escaping (Int) -> Void){
        Alamofire.request("\(Define.URL)/orders/shipper/count_order_responsed", method: .get, parameters: ["shipperId": shipperId], encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
            if let value = data.result.value as? NSDictionary{
                if let resultData = value.value(forKey: "data") as? [[String: Any]]{
                    if let firstData = resultData.first{
                        if let numberOfNotifications = firstData["size"] as? Int {
                            response(numberOfNotifications)
                        }
                    }
                }
            }
        }
    }
    
}
