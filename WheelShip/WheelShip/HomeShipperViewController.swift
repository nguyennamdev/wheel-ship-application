//
//  HomeShipperViewController.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/20/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import Alamofire

class HomeShipperViewController : UITableViewController {
    
    var user:User?
    let cellId = "cellId"
    var arrOrder:[Order] = [Order]()
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Danh sách đơn đặt hàng"
        
        self.tableView.register(HomeShipperViewCell.self, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.loadOrdersFromApi()
    }

}


// MARK: Implement UITableDataSource and UITableDelegate

extension HomeShipperViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrOrder.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? HomeShipperViewCell
        cell?.order = self.arrOrder[indexPath.row]
        cell?.userId = self.user?.uid
        cell?.shipperDelegate = self
        cell?.isSave = false
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 380
    }
}

// MARK: Implement ShipperDelegate

extension HomeShipperViewController : ShipperDelegate {
    
    func presentResponseResult(title: String, message: String) {
        self.presentAlertWithTitleAndMessage(title: title, message: message)
    }
    
    
}
