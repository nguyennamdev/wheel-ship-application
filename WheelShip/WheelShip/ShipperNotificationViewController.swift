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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.register(ShipperNotificationTableViewCell.self, forCellReuseIdentifier: cellId)
        self.navigationItem.title = "Thông báo"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.getListOrderAgreed()
        handleShowNumberOfNotification()
    }
    

    
  
    
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




