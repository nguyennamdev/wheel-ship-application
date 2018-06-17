//
//  ShipperNotificationViewController.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/22/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class ShipperNotificationViewController: UITableViewController{
    
    let cellId = "cellId"
    var user:User?
    var arrOrder:[Order] = [Order]()
    let searchViewController = UISearchController(searchResultsController: nil)
    let reachbility = Reachability.instance
    
    var timer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.refreshControl = tableRefreshControl
        self.tableView.register(ShipperNotificationTableViewCell.self, forCellReuseIdentifier: cellId)
        self.navigationItem.title = "Thông báo"
        
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(handleReloadNotifications), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if reachbility.currentReachbilityStatus(){
            self.getListOrderAgreed()
            handleShowNumberOfNotification()
        }else{
            present(reachbility.showAlertToSettingInternet(), animated: true, completion: {
                if self.reachbility.currentReachbilityStatus(){
                    self.getListOrderAgreed()
                    self.handleShowNumberOfNotification()
                }
            })
        }
    }
    
    // MARK: Actions
    @objc private func handleReloadNotifications(){
        self.getListOrderAgreed()
        self.handleShowNumberOfNotification()
    }

    // MARK: Private instance methods
    
    private func handleShowNumberOfNotification(){
        // reset number of notification
        if let shipperId = self.user?.uid{
            getNumberNotification(shipperId: shipperId, response: { (numberOfNotification) in
                let numberOfNotificationSaved = UserDefaults.standard.getNumberOfNotification()
                if numberOfNotification > numberOfNotificationSaved{
                    // get number notification will show when minus number above
                    let numberWillShow = numberOfNotification - numberOfNotificationSaved
                    self.tabBarItem.badgeValue = "\(numberWillShow)"
                    // save new number
                    UserDefaults.standard.setNumberOfNotifitcationForShipper(number: numberOfNotification)
                }else{
                    self.tabBarItem.badgeValue = nil
                }
            })
        }
    }
    
    // MARK: Views
    lazy var tableRefreshControl:UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.tintColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        rf.addTarget(self, action: #selector(handleReloadNotifications), for: .valueChanged)
        return rf
    }()

}

// MARK: Implement UITableDataSource and UITableDelegate
extension ShipperNotificationViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if arrOrder.count == 0 {
            self.tableView.setEmptyMessage("Không có thông báo nào mới")
        }else{
            self.tableView.restore()
        }
        return arrOrder.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ShipperNotificationTableViewCell
        cell?.order = self.arrOrder[indexPath.row]
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}




