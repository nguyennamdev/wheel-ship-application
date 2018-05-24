//
//  OrderComfirmationCollectionViewController.swift
//  WheelShip
//
//  Created by Nguyen Nam on 3/20/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import Alamofire

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
    
    // MARK: init parameters
    private func initParameters() -> [String: Any]?{
        // wrap data
        guard let orderId = self.order?.orderId,
            let uId = self.order?.userId,
            let originAddress = self.order?.originAddress,
            let destinationAddress = self.order?.destinationAddress,
            let oriLattitude = self.order?.originLocation?.coordinate.latitude,
            let oriLongtitude = self.order?.originLocation?.coordinate.longitude,
            let desLattitude = self.order?.destinationLocation?.coordinate.latitude,
            let desLongtitude = self.order?.destinationLocation?.coordinate.longitude,
            let distance = self.order?.distance,
            let note = self.order?.note,
            let isFragile = self.order?.isFragile,
            let phoneReceiver = self.order?.phoneReceiver,
            let weight = self.order?.weight,
            let prepayment = self.order?.unitPrice?.prepayment,
            let feeShip = self.order?.unitPrice?.feeShip,
            let overheads = self.order?.unitPrice?.overheads,
            let priceOfWeight = self.order?.unitPrice?.priceOfWeight,
            let priceOfOrderFragile = self.order?.unitPrice?.priceFragileOrder else { return nil}
        let parameter = ["orderId": orderId,
                         "userId": uId,
                         "originAddress": originAddress,
                         "destinationAddress": destinationAddress,
                         "oriLatitude": oriLattitude,
                         "oriLongtitude": oriLongtitude,
                         "desLatitude": desLattitude,
                         "desLongtitude": desLongtitude,
                         "distance": distance,
                         "isFragile": isFragile,
                         "note": note,
                         "phoneReceiver": phoneReceiver,
                         "weight": weight,
                         "prepayment": prepayment,
                         "feeShip": feeShip,
                         "priceOfWeight": priceOfWeight,
                         "priceOfOrderFragile": priceOfOrderFragile,
                         "overheads": overheads] as [String : Any]
        return parameter
    }
    
    private func showAlertHaveError(message: String){
        let alert = UIAlertController(title: "Có lỗi", message: message + "\n Vui lòng thử lại sau", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion:nil)
    }
    
    private func showAlertOrderComplete(){
        let alert = UIAlertController(title: "Đặt đơn hàng", message: "Bạn đã đặt đơn hàng thành công", preferredStyle: UIAlertControllerStyle.alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
            let homeOrdererController = self.navigationController?.viewControllers[0] as? HomeOrdererController
            self.navigationController?.popToViewController(homeOrdererController!, animated: true)
        }
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil);
    }
    // MARK: Actions
    @objc private func completeOrder(){
        // blur background
        self.collectionView?.alpha = 0.2
        // request to api to confirm order
        guard let parameters = initParameters() else { return }
        Alamofire.request("\(Define.URL)/orders/orderer/insert_new_order", method: .post, parameters: parameters, encoding: JSONEncoding.default ).responseJSON { (response) in
            if let resultValue = response.result.value as? [String:Any]{
                if let result = resultValue["result"] as? Bool{
                    if result {
                        self.collectionView?.alpha = 1;
                        self.showAlertOrderComplete()
                    }else{
                        self.collectionView?.alpha = 1;
                        let message = resultValue["message"] as? String
                        self.showAlertHaveError(message: message!)
                    }
                }
            }
        }
    }
}

// MARK: Implement functions of UICollectionViewDelegateFlowLayout
extension OrderConfirmationController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height / 10);
    }
}









