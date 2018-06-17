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
    var filteredOrders = [Order]()
    let searchViewController = UISearchController(searchResultsController: nil)
    let reachbility = Reachability.instance
    
    var timer:Timer = Timer()
    
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.refreshControl = tableRefreshControl
        self.tableView.register(HomeShipperViewCell.self, forCellReuseIdentifier: cellId)
        tableView.backgroundColor = UIColor.white
        initSearchViewController()
        
        self.timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(loadOrdersFromApi), userInfo: nil, repeats: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !reachbility.currentReachbilityStatus(){
            present(reachbility.showAlertToSettingInternet(), animated: true, completion: {
                if self.reachbility.currentReachbilityStatus(){
                    self.loadOrdersFromApi()
                }
            })
        }else{
            self.loadOrdersFromApi()
        }
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
        self.tableView.reloadData()
    }
    
    func isFiltering() -> Bool{
        return searchViewController.isActive && !searchBarIsEmpty()
    }
    
    // MARK: Views
    lazy var tableRefreshControl:UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.tintColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        rf.addTarget(self, action: #selector(handleReloadOrder), for: .valueChanged)
        return rf
    }()
    
    // MARK: Actions
    @objc func handleReloadOrder(){
        self.loadOrdersFromApi()
    }

    
}


// MARK: Implement UITableDataSource and UITableDelegate

extension HomeShipperViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering(){
            return filteredOrders.count
        }
        if (self.arrOrder.count == 0){
            self.tableView.setEmptyMessage("Không có đơn hàng để hiển thị :(")
        }else{
            self.tableView.restore()
        }
        return arrOrder.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? HomeShipperViewCell
        cell?.userId = self.user?.uid
        cell?.shipperDelegate = self
        cell?.isSave = false
        
        let order:Order
        if isFiltering(){
            order = self.filteredOrders[indexPath.row]
        }else{
            order = self.arrOrder[indexPath.row]
        }
        cell?.order = order
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 410
    }
}

// MARK: Implement ShipperDelegate

extension HomeShipperViewController : ShipperDelegate {
    
    func presentResponseResult(title: String, message: String) {
        self.presentAlertWithTitleAndMessage(title: title, message: message)
    }
    
}

// MARK: - UISearchResultsUpdating Delegate
extension HomeShipperViewController : UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scopeSelected = searchBar.selectedScopeButtonIndex
        filterContentForSearchText(searchBar.text!, indexScopeSelected: scopeSelected)
    }
    
}

// MARK: UISearchBarDelegate
extension HomeShipperViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.filterContentForSearchText(searchBar.text!, indexScopeSelected: selectedScope)
    }
    
}


