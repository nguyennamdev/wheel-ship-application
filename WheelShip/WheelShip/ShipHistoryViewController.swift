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
    var filteredOrders = [Order]()
    let searchViewController = UISearchController(searchResultsController: nil)
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor  = UIColor.white
        setupViews()
        initSearchViewController()
        
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
    
    // MARK: - Private instance methods
    func searchBarIsEmpty() -> Bool {
        // return true if the text is empty or nil
        return searchViewController.searchBar.text?.isEmpty ?? true
    }
    
    func filterContentForSearchText(_ searchText:String, indexScopeSelected:Int){
        filteredOrders = arrOrder.filter({ (order:Order) -> Bool in
            switch indexScopeSelected{
            case 0:
                return (order.orderId?.lowercased().contains(searchText.lowercased()))!
            case 1:
                return (order.originAddress?.lowercased().contains(searchText.lowercased()))! || (order.destinationAddress?.lowercased().contains(searchText))!
            case 2:
                let prepaymentString = String(order.unitPrice?.prepayment ?? 0)
                let overheadsString = String(order.unitPrice?.overheads ?? 0)
                let feeShipString = String(order.unitPrice?.feeShip ?? 0)
                return (prepaymentString.lowercased().contains(searchText.lowercased())) || overheadsString.lowercased().contains(searchText.lowercased()) || feeShipString.lowercased().contains(searchText.lowercased())
            case 3:
                let distanceString = String(order.distance ?? 0)
                return distanceString.lowercased().contains(searchText.lowercased())
            default:
                return (order.orderId?.lowercased().contains(searchText.lowercased()))!
            }
        })
        ordersTableView.reloadData()
    }
    
    func isFiltering() -> Bool{
        return searchViewController.isActive && !searchBarIsEmpty()
    }
    
    // MARK: setup views
    private func initSearchViewController(){
        // setup the scope bar
        searchViewController.searchBar.scopeButtonTitles = ["Mã đơn hàng", "Địa chỉ", "Phí", "Khoảng cách"]
        searchViewController.searchBar.delegate = self
        searchViewController.searchBar.selectedScopeButtonIndex = 0
        // setup search viewcontroller
        searchViewController.searchResultsUpdater = self
        searchViewController.obscuresBackgroundDuringPresentation = false
        searchViewController.searchBar.placeholder = "Tìm kiếm"
        self.navigationItem.searchController = searchViewController
    }
    
    
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
        if isFiltering(){
            return filteredOrders.count
        }
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
    
        let order:Order
        if isFiltering(){
            order = filteredOrders[indexPath.row]
        }else{
            order = arrOrder[indexPath.row]
        }
        cell?.order = order
        // if status = had shipper, cell will disenable cancel button
        cell?.isEnabledCancelButton = order.status
        // if order completed, cell will remove stack buttons
        cell?.isCompletedOrder = order.isCompleted
        // show buttons need in cell
        if orderStatusSegment.selectedSegmentIndex == 0 {
            cell?.isHadAcceptButton = true
        }else{
            cell?.isHadAcceptButton = false
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.arrOrder[indexPath.row].isCompleted! {
            return 360
        }
        return 400
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

// MARK: - UISearchResultsUpdating Delegate
extension ShipHistoryViewController : UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scopeSelected = searchBar.selectedScopeButtonIndex
        filterContentForSearchText(searchBar.text!, indexScopeSelected: scopeSelected)
    }

}

// MARK: UISearchBarDelegate
extension ShipHistoryViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.filterContentForSearchText(searchBar.text!, indexScopeSelected: selectedScope)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.orderStatusSegment.isHidden = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.orderStatusSegment.isHidden = false
    }
    
}



