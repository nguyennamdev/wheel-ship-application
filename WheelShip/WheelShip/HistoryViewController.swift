//
//  HistoryViewController.swift
//  WheelShip
//
//  Created by Nguyen Nam on 4/19/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class AAA {
    var isShowing:Bool = false
}

class HistoryViewController: UIViewController {
    
    let cellId = "cellId"
    var isShowing: Bool = false
    var listOrders:[AAA]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        self.navigationItem.title = "Lịch sử đặt hàng"
        ordersCollectionView.dataSource = self
        ordersCollectionView.delegate = self
        ordersCollectionView.backgroundColor = UIColor.clear
        dummyOrder()
        // register collection view
        ordersCollectionView.register(OrdersHistoryCollectionCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    
    private func dummyOrder(){
        listOrders = [AAA]()
        listOrders = [
            AAA(),
            AAA(),
            AAA()
        ]
    }
    
    // MARK: Private funtions
    private func setupViews(){
        view.addSubview(background)
        background.frame = view.frame
        setupStatusOrderSegment()
        setupOrdersCollectionView()
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
        
    }
    
}


// CollectionView delegate and datasource
extension HistoryViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOrders?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? OrdersHistoryCollectionCell
        cell?.a = listOrders?[indexPath.row]
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if listOrders![indexPath.row].isShowing{
            return CGSize(width: view.bounds.width, height: 200)
        }else{
            return CGSize(width: view.bounds.width, height: 130)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if listOrders![indexPath.row].isShowing{
            listOrders![indexPath.row].isShowing = false
        }else {
            listOrders![indexPath.row].isShowing = true
        }
        self.ordersCollectionView.reloadData()
    }

}

