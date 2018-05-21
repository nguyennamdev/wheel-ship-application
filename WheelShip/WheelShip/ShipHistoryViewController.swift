//
//  ShipHistoryViewController.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/21/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class ShipHistoryViewController : UIViewController{
    
    var user:User?
    let cellId = "cellId"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor  = UIColor.white
        setupViews()
        
    }
    
    // MARK: Actions
    @objc func orderStatusSegmentValueChanged(sender:UISegmentedControl){
        ordersTableView.reloadData()
    }
    
    
    // MARK: Call apis
    
    
    
    // MARK: setup views
    private func setupViews(){
        setupOrderStatusSegment()
        setupOrdersTableView()
    }
    
    private func setupOrderStatusSegment(){
        self.view.addSubview(self.orderStatusSegment)
        orderStatusSegment.anchorWithConstants(top: self.view.safeAreaLayoutGuide.topAnchor, left: self.view.leftAnchor, bottom: nil, right: self.view.rightAnchor, topConstant: 12, leftConstant: 24, bottomConstant: 0, rightConstant: 24)
    }
    
    private func setupOrdersTableView(){
        self.view.addSubview(ordersTableView)
        ordersTableView.anchorWithConstants(top: orderStatusSegment.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor)
        ordersTableView.delegate = self
        ordersTableView.dataSource = self
        ordersTableView.register(ShipHistoryViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    // MARK: Views
    let orderStatusSegment:UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Đã lưu", "Chờ phản hồi", "Đã hoàn thành"])
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(orderStatusSegmentValueChanged(sender:)), for: .valueChanged)
        return segment
    }()
    
    let ordersTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.white
        return tableView
    }()
    
}

// MARK: Implement UITableViewDataSource and UITableViewDelegate
extension ShipHistoryViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ShipHistoryViewCell
        cell?.userId = self.user?.uid
        cell?.shipperDelegate = self
        if orderStatusSegment.selectedSegmentIndex == 0 {
            cell?.isHadAcceptButton = true
        }else{
            cell?.isHadAcceptButton = false
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 335
    }
    
}

// MARK: Implement ShipperDelegate
extension ShipHistoryViewController : ShipperDelegate {
    
    func responseAcceptRequest(title: String, message: String) {
        self.presentAlertWithTitleAndMessage(title: title, message: message)
    }
    
}



