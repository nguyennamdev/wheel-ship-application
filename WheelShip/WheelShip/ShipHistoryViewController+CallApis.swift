//
//  ShipHistoryViewController+CallApis.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/22/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//
import Alamofire


extension ShipHistoryViewController {
    
    // MARK: Call apis
    public func callApiToGetListOrderSaved(){
        callApiToGetListOrder(url: "\(Define.URL)/orders/shipper/order_saved_by_shipper")
    }
    
    
    public func callApiToGetListOrderAccepted(){
        callApiToGetListOrder(url: "\(Define.URL)/orders/shipper/order_accepted_by_shipper")
    }
    
    public func callApiToGetListOrderCompleted(){
        callApiToGetListOrder(url: "\(Define.URL)/orders/shipper/list_order_completed")
    }
    
    private func callApiToGetListOrder(url:String){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        if let shipperId = self.user?.uid {
            Alamofire.request(url, method: .get, parameters: ["shipperId": shipperId], encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
                if let value = data.result.value as? [String: Any]{
                    if let result = value["result"] as? Bool {
                        if result{
                            if let orderDict = value["data"] as? [NSDictionary]{
                                self.arrOrder.removeAll()
                                // make instance order to add array order
                                for dict in orderDict{
                                    let order = Order()
                                    order.setValueByNSDictionary(dictionary: dict)
                                    self.arrOrder.append(order)
                                }
                                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                                self.ordersTableView.reloadData()
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    public func callApiToUnsaveOrder(orderId:String, userId:String){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request("\(Define.URL)/users/unsave_order", method: .put, parameters: ["orderId": orderId, "uid": userId], encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
            self.loadAgainData()
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
  
    
}
