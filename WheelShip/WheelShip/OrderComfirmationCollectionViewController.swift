//
//  OrderComfirmationCollectionViewController.swift
//  WheelShip
//
//  Created by Nguyen Nam on 3/20/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class OrderConfirmationController : UICollectionViewController {
    
    let cellId = "cellId"
    // MARK: Properties 
    var order:Order?{
        didSet{
            self.items = order?.getConfirmationItems()
        }
    }
    var items:[ConfirmationItem]?{
        didSet{
            self.collectionView?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // config collection view
        self.collectionView?.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        self.collectionView?.register(OrderConfirmationCell.self, forCellWithReuseIdentifier: cellId)
        self.collectionView?.alwaysBounceVertical = true
        
        self.navigationItem.title = "Xác nhận"
        initRightBarButtonItem()
       
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! OrderConfirmationCell
        cell.confirmationItem = items?[indexPath.row]
        return cell
    }
    // MARK: Private functions
    private func initRightBarButtonItem(){
        let rightBarButtonItem = UIBarButtonItem(title: "Xong", style: .done, target: self, action: #selector(completeOrder))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    // MARK: Actions
    @objc private func completeOrder(){
        print("done")
        let homeOrdererController = self.navigationController?.viewControllers[0] as? HomeOrdererController
        self.navigationController?.popToViewController(homeOrdererController!, animated: true)
    }
    
    // MARK: Views
    let background:GradientView = {
        let gv = GradientView()
        gv.colors = [ UIColor.rgb(r: 190, g: 147, b: 197).cgColor,
                      UIColor.rgb(r: 123, g: 198, b: 204).cgColor]
        return gv
    }()
}

// MARK: Implement functions of UICollectionViewDelegateFlowLayout
extension OrderConfirmationController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 50)
    }
}









