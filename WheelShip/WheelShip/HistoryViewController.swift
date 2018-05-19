//
//  HistoryViewController.swift
//  WheelShip
//
//  Created by Nguyen Nam on 4/19/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import Alamofire

class HistoryViewController: UIViewController {
    
    let cellId = "cellId"
    var user:User?{
        didSet{
            print(user?.name)
        }
    }
    var arrOrder:[Order]?
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        self.navigationItem.title = "Lịch sử đặt hàng"
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
    
    // MARK: Private funtions
    private func setupViews(){
        view.addSubview(background)
        background.frame = view.frame
        setupStatusOrderSegment()
        setupOrdersCollectionView()
    }
    
    private func loadOrderById(urlString: String){
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
        self.loadOrderById(urlString: "https://wheel-ship.herokuapp.com/orders/order_complete")
    }
    
    private func loadOrderWaitShipperById(){
        self.loadOrderById(urlString: "https://wheel-ship.herokuapp.com/orders/order_by_user")
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
extension HistoryViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.arrOrder?.count == 0){
            ordersCollectionView.setEmptyMessage("Không có dữ liệu để hiển thị :(")
        }else{
            self.ordersCollectionView.restore()
        }
        return arrOrder?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? OrdersHistoryCollectionCell
        cell?.oder = self.arrOrder?[indexPath.row]
        cell?.orderHistoryDelegate = self 
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (self.arrOrder?[indexPath.row].isShowing)!{
            return CGSize(width: view.bounds.width, height: 250)
        }else{
            return CGSize(width: view.bounds.width, height: 150)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.arrOrder?[indexPath.row].isShowing = !(self.arrOrder?[indexPath.row].isShowing)!
        self.ordersCollectionView.reloadData()
    }
    
}

// MARK: Implement OrdersHistoryDelegate
extension HistoryViewController : OrdersHistoryDelegate {
    
    func deleteAOrderByOrderId(orderId: String) {
        let parameter:Parameters = ["orderId": orderId]
        Alamofire.request("https://wheel-ship.herokuapp.com/orders/delete_order", method: .delete, parameters: parameter, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
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

