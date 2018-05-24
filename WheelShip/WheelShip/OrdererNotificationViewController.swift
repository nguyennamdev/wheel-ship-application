//
//  OrdererNotificationViewController.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/23/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class OrdererNotificationViewController : UITableViewController {
    
    let cellId:String = "cellId"
    var user:User?
    var arrOrder:[Order] = [Order]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Thông báo"
        
        self.tableView.register(OrdererNotificationTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        callApiToGetRequestsFromShipper()
        if let urerId = self.user?.uid {
            getNumberOfNotificationForOrderer(ordererId: urerId) { (number) in
                number == 0 ? (self.tabBarItem.badgeValue = "") : (self.tabBarItem.badgeValue = "\(number)")
            }
        }
    }
    
}

// MARK: Implement OrdererNotificationViewController

extension OrdererNotificationViewController{
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrOrder.count == 0{
            tableView.setEmptyMessage("Không có thông báo mới nào")
        }else{
            tableView.restore()
        }
        return arrOrder.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? OrdererNotificationTableViewCell
        cell?.order = self.arrOrder[indexPath.row]
        cell?.ordererNotificationDelegate = self
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}

// MARK: Implemt OrdererNotificatioDelegate
extension OrdererNotificationViewController : OrdererNotificationDelegate{
    
    func responseToShip(orderId: String, shipperId: String, isAgree: Bool) {
        isAgree == true ? ordererAgreeShipperToShip(orderId: orderId, shipperId: shipperId) : ordererDisAgreeShipperToShip(orderId: orderId, shiperId: shipperId)
        if let ordererId = self.user?.uid {
            getNumberOfNotificationForOrderer(ordererId: ordererId, response: { (numberOfNotification) in
                numberOfNotification == 0 ? (self.tabBarItem.badgeValue = "") : (self.tabBarItem.badgeValue = "\(numberOfNotification)")
            })
        }
    }
}

