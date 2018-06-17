//
//  HomeShipViewController+CallApis.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/22/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import Alamofire

extension HomeShipperViewController {
    
    // MARK: Call Api
    @objc public func loadOrdersFromApi(){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        Alamofire.request("\(Define.URL)/orders/shipper/list_order", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (data) in
            if let value = data.result.value as? NSDictionary {
                if let orderDictionary = value.value(forKey: "data") as? [NSDictionary] {
                    self.arrOrder.removeAll()
                    for dict in orderDictionary{
                        let order = Order()
                        order.setValueByNSDictionary(dictionary: dict)
                        // append to arr order
                        self.arrOrder.append(order)
                    }
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.tableRefreshControl.endRefreshing()
                    self.tableView.reloadData()
                }
            }
        }
    }
    
   
}

