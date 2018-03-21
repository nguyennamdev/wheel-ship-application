//
//  Order+CoreDataProperties.swift
//  WheelShip
//
//  Created by Nguyen Nam on 3/20/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//
//

import Foundation
import CoreData


extension Order {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }
    
    @NSManaged public var orderId: String?
    @NSManaged public var originAddress: String?
    @NSManaged public var destinationAddress: String?
    @NSManaged public var startTime: Int32
    @NSManaged public var stopTime: Int32
    @NSManaged public var note: String?
    @NSManaged public var originLocation: Location?
    @NSManaged public var destinationLocation: Location?
    @NSManaged public var phoneOrderer: String?
    @NSManaged public var phoneReceiver: String?
    @NSManaged public var prepayment: Double
    @NSManaged public var feeShip: Double
    @NSManaged public var status: String?
    @NSManaged public var isFragile: Bool
    @NSManaged public var weight: String?
    @NSManaged public var shipper: Shipper?

    public var overheads:Double{
        return prepayment + feeShip + 1000
    }
    
}
