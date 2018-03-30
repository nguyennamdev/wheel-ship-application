//
//  Order+CoreDataProperties.swift
//  WheelShip
//
//  Created by Nguyen Nam on 3/30/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//
//

import Foundation
import CoreData


extension Order {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Order> {
        return NSFetchRequest<Order>(entityName: "Order")
    }

    @NSManaged public var destinationAddress: String?
    @NSManaged public var destinationLocation: NSObject?
    @NSManaged public var isFragile: Bool
    @NSManaged public var note: String?
    @NSManaged public var orderId: String?
    @NSManaged public var originAddress: String?
    @NSManaged public var originLocation: NSObject?
    @NSManaged public var phoneOrderer: String?
    @NSManaged public var phoneReceiver: String?
    @NSManaged public var startTime: Int32
    @NSManaged public var status: String?
    @NSManaged public var stopTime: Int32
    @NSManaged public var weight: String?
    @NSManaged public var shipper: Shipper?
    @NSManaged public var unitPrice: UnitPrice?

}
