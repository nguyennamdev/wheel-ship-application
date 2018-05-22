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
    var arrOrder:[Order] = [Order]()

    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Thư viện"
        view.backgroundColor  = UIColor.white
        setupViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        switch orderStatusSegment.selectedSegmentIndex {
        case 0:
            callApiToGetListOrderSaved()
        case 1:
            callApiToGetListOrderAccepted()
        default:
            break
        }
        
    }
    
    func loadAgainData(){
        switch orderStatusSegment.selectedSegmentIndex {
        case 0:
            callApiToGetListOrderSaved()
        case 1:
            callApiToGetListOrderAccepted()
        case 2:
            callApiToGetListOrderCompleted()
        default:
            break
        }
        ordersTableView.reloadData()
    }
    
    // MARK: Actions
    @objc func orderStatusSegmentValueChanged(sender:UISegmentedControl){
        loadAgainData()
    }
    
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
        ordersTableView.anchorWithConstants(top: orderStatusSegment.bottomAnchor, left: self.view.leftAnchor, bottom: self.view.bottomAnchor, right: self.view.rightAnchor, topConstant: 12)
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
        if (self.arrOrder.count == 0){
            self.ordersTableView.setEmptyMessage("Không có đơn hàng để hiển thị :(")
        }else{
            self.ordersTableView.restore()
        }
        return arrOrder.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? ShipHistoryViewCell
        cell?.userId = self.user?.uid
        cell?.shipperDelegate = self
        cell?.order = self.arrOrder[indexPath.row]
        cell?.isEnabledCancelButton = self.arrOrder[indexPath.row].status
        cell?.isCompletedOrder = self.arrOrder[indexPath.row].isCompleted
        
        if orderStatusSegment.selectedSegmentIndex == 0 {
            cell?.isHadAcceptButton = true
        }else{
            cell?.isHadAcceptButton = false
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.arrOrder[indexPath.row].isCompleted! {
            return 340
        }
        return 380
    }
    
}

// MARK: Implement ShipperDelegate
extension ShipHistoryViewController : ShipperDelegate {
    
    func unsaveOrder(orderId: String, userId: String) {
        callApiToUnsaveOrder(orderId: orderId, userId: userId)
    }
    
    func presentResponseResult(title: String, message: String) {
        self.presentAlertWithTitleAndMessage(title: title, message: message)
        loadAgainData()
    }
    
    func shipperCall(phoneOrderer: String, phoneReceiver: String) {
        if orderStatusSegment.selectedSegmentIndex == 0 {
            if let url = URL(string: "tel://\(phoneOrderer)"),
                UIApplication.shared.canOpenURL(url){
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }else {
            let alert = UIAlertController(title: "Gọi điện", message: "Bạn muốn gọi điện cho ai?", preferredStyle: .actionSheet)
            let callOrdererAction = UIAlertAction(title: "Người đặt hàng", style: .default, handler: { (action) in
                if let url = URL(string: "tel://\(phoneOrderer)"),
                    UIApplication.shared.canOpenURL(url){
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            })
            let callReceiverAction = UIAlertAction(title: "Nguời nhận hàng", style: .default, handler: { (action) in
                if let url = URL(string: "tel://\(phoneReceiver)"),
                    UIApplication.shared.canOpenURL(url){
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            })
            let cancelAction = UIAlertAction(title: "Huỷ", style: .cancel, handler: nil)
            alert.addAction(callOrdererAction)
            alert.addAction(callReceiverAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }
    
}



