//
//  Order+CoreDataClass.swift
//  WheelShip
//
//  Created by Nguyen Nam on 2/4/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//
//

import Foundation
import CoreData
import CoreLocation

@objc(Order)
public class Order: NSManagedObject {
    
    public func getConfirmationItems() -> [ConfirmationItem]{
        var item = [ConfirmationItem]()
        if let originAddress = self.originAddress{
            item.append(ConfirmationItem(image: #imageLiteral(resourceName: "placeholder"), title: "Điểm bắt đầu", content: originAddress))
        }
        if let destinationAddress = self.destinationAddress{
            item.append(ConfirmationItem(image: #imageLiteral(resourceName: "placeholder2"), title: "Điểm giao hàng", content: destinationAddress))
        }
        if let weight = self.weight{
            item.append(ConfirmationItem(image: #imageLiteral(resourceName: "weight"), title: "Khối lượng", content: weight))
        }
        if self.isFragile{
            item.append(ConfirmationItem(image: #imageLiteral(resourceName: "fragile"), title: "Hàng", content: "Dễ vỡ"))
        }
        if let note = self.note{
            item.append(ConfirmationItem(image: #imageLiteral(resourceName: "pencil"), title: "Ghi chú", content: note))
        }
        if let unitPrice = self.unitPrice{
            item.append(ConfirmationItem(image: #imageLiteral(resourceName: "coin"), title: "Tiền trả trước", content: "\(unitPrice.prepayment.formatedNumberWithUnderDots()) vnđ"))
            item.append(ConfirmationItem(image: #imageLiteral(resourceName: "coin"), title: "Phí vận chuyển", content: "\(unitPrice.feeShip.formatedNumberWithUnderDots()) vnđ"))
            item.append(ConfirmationItem(image: #imageLiteral(resourceName: "coin"), title: "Tổng tiền", content: "\(unitPrice.overheads.formatedNumberWithUnderDots()) vnđ"))
        }
        return item
    }
    
    
}
