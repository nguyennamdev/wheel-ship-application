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
    let reachbility = Reachability.instance
    var timer:Timer!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Thông báo"
        
        self.tableView.refreshControl = self.tableRefreshControl
        self.tableView.register(OrdererNotificationTableViewCell.self, forCellReuseIdentifier: cellId)
        
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(handleReloadNotification), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !reachbility.currentReachbilityStatus(){
            present(reachbility.showAlertToSettingInternet(), animated: true, completion: nil)
        }
        loadNotifications()
    }
    
    // MARK: Actions
    @objc private func handleReloadNotification(){
        loadNotifications()
    }
    
    // MARK: Private instance methods
    private func loadNotifications(){
        callApiToGetRequestsFromShipper()
        if let urerId = self.user?.uid {
            getNumberOfNotificationForOrderer(ordererId: urerId) { (number) in
                number == 0 ? (self.tabBarItem.badgeValue = nil) : (self.tabBarItem.badgeValue = "\(number)")
            }
        }
    }
    
    // MARK: Views
    lazy var tableRefreshControl: UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        rf.addTarget(self, action: #selector(handleReloadNotification), for: .valueChanged)
        return rf
    }()
    
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

