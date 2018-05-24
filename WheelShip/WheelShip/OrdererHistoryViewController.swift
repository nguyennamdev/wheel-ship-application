//
//  HistoryViewController.swift
//  WheelShip
//
//  Created by Nguyen Nam on 4/19/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import Alamofire

class OrdererHistoryViewController: UIViewController {
    
    let cellId = "cellId"
    var user:User?
    var arrOrder:[Order]?
    var filteredOrder:[Order] = [Order]()
    
    var searchViewController: UISearchController = UISearchController(searchResultsController: nil)
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        ordersCollectionView.backgroundColor = UIColor.clear
        self.ordersCollectionView.dataSource = self
        self.ordersCollectionView.delegate = self
        // register collection view
        ordersCollectionView.register(OrdersHistoryCollectionCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.statusOrderSegment.selectedSegmentIndex == 0{
            self.loadOrderWaitShipperById()
        }else{
            self.loadOrderCompleteById()
        }
    }
    
    // MARK: Private instance methods
    private func setupViews(){
        view.addSubview(background)
        background.frame = view.frame
        setupStatusOrderSegment()
        setupOrdersCollectionView()
        setupSearchViewController()
    }
    
    private func setupSearchViewController(){
        // setup scope to seach bar
        searchViewController.searchBar.scopeButtonTitles = ["Mã vận chuyển", "Địa chỉ", "Phí"]
        searchViewController.searchBar.delegate = self
        searchViewController.searchBar.selectedScopeButtonIndex = 0
        
        // setup searchViewController
        self.navigationItem.searchController = searchViewController
        searchViewController.searchResultsUpdater = self
        searchViewController.dimsBackgroundDuringPresentation = false
        searchViewController.obscuresBackgroundDuringPresentation = false
        searchViewController.searchBar.placeholder = "Tìm kiếm"
    }
    
    private func searchBarTextIsEmpty() -> Bool{
        // return true if search is empty or nil
        return searchViewController.searchBar.text?.isEmpty ?? true
    }
    
    private func isFiltering() -> Bool{
        // return true when search bar is active and text is not null
        return searchViewController.isActive && !searchBarTextIsEmpty()
    }
    
    private func filterContentForSearchText(_ searchText:String, indexOfScopeSelected:Int){
        filteredOrder = self.arrOrder!.filter({ (order) -> Bool in
            switch indexOfScopeSelected{
            case 0:
                // filter by order id
                return (order.orderId?.lowercased().contains(searchText.lowercased()))!
            case 1:
                // filter by origin address or destination address
                return (order.originAddress?.lowercased().contains(searchText.lowercased()))! || (order.destinationAddress?.lowercased().contains(searchText.lowercased()))!
            case 2:
                let prepaymentString = String(order.unitPrice?.prepayment ?? 0)
                let overheadsString = String(order.unitPrice?.overheads ?? 0)
                let feeShipString = String(order.unitPrice?.feeShip ?? 0)
                // filter by prepayment or overheads or feeship
                return (prepaymentString.lowercased().contains(searchText.lowercased())) || overheadsString.lowercased().contains(searchText.lowercased()) || feeShipString.lowercased().contains(searchText.lowercased())
            default:
                return (order.orderId?.lowercased().contains(searchText.lowercased()))!
            }
        })
        ordersCollectionView.reloadData()
    }
    
    
    
    private func loadOrderByOrdererId(urlString: String){
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
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
    }
    
    private func loadOrderCompleteById(){
        self.loadOrderByOrdererId(urlString: "\(Define.URL)/orders/orderer/order_complete")
    }
    
    private func loadOrderWaitShipperById(){
        self.loadOrderByOrdererId(urlString: "\(Define.URL)/orders/orderer/order_by_user")
    }
    
    // MARK: Views
    let background:GradientView = {
        let gv = GradientView()
        gv.setupDefaultColor()
        return gv
    }()
    
    let statusOrderSegment:UISegmentedControl = {
        let segment = UISegmentedControl(items: ["Đơn đang đặt", "Đơn hoàn thành"])
        segment.addTarget(self, action: #selector(statusOrderSegmentValueChanged(sender:)), for: .valueChanged)
        segment.selectedSegmentIndex = 0
        segment.backgroundColor = UIColor.white
        segment.clipsToBounds = true
        segment.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        return segment
    }()
    
    let ordersCollectionView:UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        return collectionView
    }()
    
    // MARK: Actions
    @objc func statusOrderSegmentValueChanged(sender: UISegmentedControl){
        if sender.selectedSegmentIndex == 0{
            self.loadOrderWaitShipperById()
        }else{
            self.loadOrderCompleteById()
        }
    }
    
}

// MARK: CollectionView delegate and datasource
extension OrdererHistoryViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.arrOrder?.count == 0){
            ordersCollectionView.setEmptyMessage("Không có dữ liệu để hiển thị :(")
        }else{
            self.ordersCollectionView.restore()
        }
        if isFiltering(){
            return filteredOrder.count
        }
        return arrOrder?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? OrdersHistoryCollectionCell
        cell?.orderHistoryDelegate = self
        var order:Order
        if isFiltering(){
            order = filteredOrder[indexPath.row]
        }else{
            order = arrOrder![indexPath.row]
        }
        cell?.order = order
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let order:Order
        if isFiltering(){
            order = filteredOrder[indexPath.row]
        }else{
            order = (arrOrder?[indexPath.row])!
        }
        if order.isShowing{
            return CGSize(width: view.bounds.width, height: 280)
        }
        return CGSize(width: view.bounds.width, height: 180)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isFiltering(){
            self.filteredOrder[indexPath.row].isShowing = !filteredOrder[indexPath.row].isShowing
        }else{
            self.arrOrder?[indexPath.row].isShowing = !(self.arrOrder?[indexPath.row].isShowing)!
        }
        self.ordersCollectionView.reloadData()
    }
    
}

// MARK: Implement OrdersHistoryDelegate
extension OrdererHistoryViewController : OrdersHistoryDelegate {
    
    func deleteAOrderByOrderId(orderId: String) {
        let parameter:Parameters = ["orderId": orderId]
        Alamofire.request("\(Define.URL)/orders/orderer/delete_order", method: .delete, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            if let value = response.result.value as? [String: Any] {
                if let result = value["result"] as? Bool{
                    if result {
                        self.statusOrderSegment.selectedSegmentIndex == 0 ? self.loadOrderWaitShipperById() : self.loadOrderCompleteById()
                    }
                }
            }
        }
    }
    
    func editAOrderByOrderId(orderId: String) {
        let editViewController = EditOrderViewController(nibName: "EditOrderViewController", bundle: nil)
        editViewController.orderIdToEdit = orderId
        self.navigationController?.pushViewController(editViewController, animated: true)
    }
}

// MARK: - UISearchResultUpdating Delegate
extension OrdererHistoryViewController : UISearchResultsUpdating{
    
    func updateSearchResults(for searchController: UISearchController) {
        let selectedScope = searchController.searchBar.selectedScopeButtonIndex
        filterContentForSearchText(searchController.searchBar.text!, indexOfScopeSelected: selectedScope)
    }
}

// MARK: - UISearchBarDelegate
extension OrdererHistoryViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, indexOfScopeSelected: selectedScope)
    }
    
}


