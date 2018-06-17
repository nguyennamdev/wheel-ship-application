//
//  File.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/25/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import Alamofire

extension OrdererHistoryViewController {
    
     func loadOrderByOrdererId(urlString: String){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        guard let user = self.user else { return }
        Alamofire.request(urlString, method: .get, parameters: ["userId": user.uid!] , encoding: URLEncoding.default, headers: nil).responseJSON { (dataResponse) in
            if let resultValue = dataResponse.result.value as? NSDictionary{
                // check size of data response
                if let size = resultValue.value(forKey: "size") as? Int{
                    if size > 0 {
                        if let data = resultValue.value(forKey: "data") as? [NSDictionary]{
                            self.arrOrder = [Order]()
                            for element in data{
                                let order = Order()
                                order.setValueByNSDictionary(dictionary: element)
                                self.arrOrder?.append(order);
                            }
                            self.ordersCollectionView.reloadData()
                        }
                    }else{
                        self.arrOrder = [Order]()
                        self.ordersCollectionView.reloadData()
                    }
                }
                self.refreshControl.endRefreshing()
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    func loadOrderCompleteById(){
        self.loadOrderByOrdererId(urlString: "\(Define.URL)/orders/orderer/order_complete")
    }
    
    func loadOrderWaitShipperById(){
        self.loadOrderByOrdererId(urlString: "\(Define.URL)/orders/orderer/order_by_user")
    }
    
}
