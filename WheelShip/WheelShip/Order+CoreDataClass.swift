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
        if let fromAddress = self.originAddress{
            item.append(ConfirmationItem(image: #imageLiteral(resourceName: "placeholder"), title: "Điểm bắt đầu", content: fromAddress))
        }
        if let toAddress = self.destinationAddress{
            item.append(ConfirmationItem(image: #imageLiteral(resourceName: "placeholder2"), title: "Điểm giao hàng", content: toAddress))
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
        item.append(ConfirmationItem(image: #imageLiteral(resourceName: "coin"), title: "Tiền trả trước", content: "\(prepayment.formatedNumberWithUnderDots()) vnđ"))
        item.append(ConfirmationItem(image: #imageLiteral(resourceName: "coin"), title: "Phí vận chuyển", content: "\(feeShip.formatedNumberWithUnderDots()) vnđ"))
        item.append(ConfirmationItem(image: #imageLiteral(resourceName: "coin"), title: "Tổng tiền", content: "\(overheads.formatedNumberWithUnderDots()) vnđ"))
        return item
    }
    
    public func setFromLocation(value:CLLocationCoordinate2D){
        setLocation(location: self.originLocation!, value: value)
    }
    
    public func setToLocation(value:CLLocationCoordinate2D){
        setLocation(location: self.destinationLocation!, value: value)
    }
    private func setLocation(location:Location, value:CLLocationCoordinate2D){
        location.lattitude = value.latitude
        location.longtitude = value.longitude
    }

}
