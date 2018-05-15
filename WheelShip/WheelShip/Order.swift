//
//  Order.swift
//  WheelShip
//
//  Created by Nguyen Nam on 4/7/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Foundation
import CoreLocation

class Order: NSObject {
    
    // MARK: Properties
    public var orderId: String?
    public var userId: String?
    public var originAddress: String?
    public var originLocation: CLLocation?
    public var destinationAddress: String?
    public var destinationLocation: CLLocation?
    public var distance: Double?
    public var isFragile: Bool = false
    public var note: String?
    public var phoneReceiver: String?
    public var unitPrice: UnitPrice?
    public var startTime: String?
    public var stopTime: String?
    public var status: OrderStage?
    public var weight: String?
    public var shipperId: String?
    public var isShowing: Bool = false 
    
    
    override init() {
    }
    
    init(_ originAddress: String,_ originLocation: CLLocation,_ destinationAddress: String,_ destinationLocation: CLLocation) {
        self.originAddress = originAddress
        self.originLocation = originLocation
        self.destinationAddress = destinationAddress
        self.destinationLocation = destinationLocation
    }
    
    public func setValueByNSDictionary(dictionary: NSDictionary){
        self.orderId = dictionary.value(forKey: "orderId") as? String;
        self.userId = dictionary.value(forKey: "userId") as? String;
        self.originAddress = dictionary.value(forKey: "originAddress") as? String;
        self.destinationAddress = dictionary.value(forKey: "destinationAddress") as? String;
        self.originLocation = CLLocation(latitude: dictionary.value(forKeyPath: "originLocation.latitude") as! CLLocationDegrees, longitude: dictionary.value(forKeyPath: "originLocation.longtitude") as! CLLocationDegrees)
        self.destinationLocation = CLLocation(latitude: dictionary.value(forKeyPath: "destinationLocation.latitude") as! CLLocationDegrees, longitude: dictionary.value(forKeyPath: "destinationLocation.longtitude") as! CLLocationDegrees)
        self.distance = dictionary.value(forKey: "distance") as? Double;
        self.isFragile = dictionary.value(forKey: "isFragile") as! Bool;
        self.note = dictionary.value(forKey: "note") as? String;
        self.phoneReceiver = dictionary.value(forKey: "phoneReceiver") as? String;
        self.startTime = dictionary.value(forKey: "startTime") as? String;
        self.stopTime = dictionary.value(forKey: "stopTime") as? String;
        self.status = OrderStage(rawValue: (dictionary.value(forKey: "status") as? Int16)!);
        self.weight = dictionary.value(forKey: "weight") as? String;
        // unit price
        self.unitPrice = UnitPrice()
        self.unitPrice?.prepayment = (dictionary.value(forKey: "prepayment") as? Double)!
        self.unitPrice?.priceOfWeight = dictionary.value(forKey: "priceOfWeight") as? Double;
        self.unitPrice?.priceFragileOrder = dictionary.value(forKey: "priceOfOrderFragile") as? Double;
        self.unitPrice?.feeShip = (dictionary.value(forKey: "feeShip") as? Double)!
        self.shipperId = dictionary.value(forKey: "shipperId") as? String
    }
    
    
    public func getConfirmationItems() -> [ConfirmationItem]{
        var item = [ConfirmationItem]()
        if let originAddress = self.originAddress{
            item.append(ConfirmationItem(image: #imageLiteral(resourceName: "placeholder"), title: "\(Define.ORIGIN_ADDRESS)", content: originAddress))
        }
        if let destinationAddress = self.destinationAddress{
            item.append(ConfirmationItem(image: #imageLiteral(resourceName: "placeholder2"), title: "\(Define.DESTINATION_ADDRESS)", content: destinationAddress))
        }
        if let phoneReceiver = self.phoneReceiver{
            item.append(ConfirmationItem(image: #imageLiteral(resourceName: "telephone"), title: "\(Define.PHONE_RECEIVER)", content: "\(phoneReceiver)"))
        }
        if let weight = self.weight{
            if let priceOfWeight = self.unitPrice?.priceOfWeight {
                item.append(ConfirmationItem(image: #imageLiteral(resourceName: "weight"), title: "\(Define.WEIGHT_STRING)", content: "\(weight) = +\(priceOfWeight.formatedNumberWithUnderDots())"))
            }
        }
        if let note = self.note{
            item.append(ConfirmationItem(image: #imageLiteral(resourceName: "pencil"), title: "Ghi chú", content: note))
        }
        if let unitPrice = self.unitPrice{
            if let priceFragileOrder = unitPrice.priceFragileOrder {
                item.append(ConfirmationItem(image: #imageLiteral(resourceName: "fragile"), title: "\(Define.ORDER_FRAGILE_STRING)", content: "+\(priceFragileOrder.formatedNumberWithUnderDots()) vnđ"))
            }
            item.append(ConfirmationItem(image: #imageLiteral(resourceName: "coin"), title: "\(Define.PREPAYMENT)", content: "\(unitPrice.prepayment.formatedNumberWithUnderDots()) vnđ"))
            item.append(ConfirmationItem(image: #imageLiteral(resourceName: "coin"), title: "\(Define.FEESHIP)", content: "\(unitPrice.feeShip.formatedNumberWithUnderDots()) vnđ"))
            item.append(ConfirmationItem(image: #imageLiteral(resourceName: "coin"), title: "\(Define.OVERHEADS)", content: "\(unitPrice.overheads.formatedNumberWithUnderDots()) vnđ"))
            
        }
        return item
    }
}
