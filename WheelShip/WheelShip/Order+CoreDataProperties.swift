//
//  Order+CoreDataProperties.swift
//  WheelShip
//
//  Created by Nguyen Nam on 2/4/18.
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
    @NSManaged public var fromAddress: String?
    @NSManaged public var toAddress: String?
    @NSManaged public var startTime: NSDate?
    @NSManaged public var stopTime: NSDate?
    @NSManaged public var descriptionText: String?
    @NSManaged public var fromLocation: Location?
    @NSManaged public var toLocation: Location?
    @NSManaged public var phoneOrderer: String?
    @NSManaged public var phoneReceiver: String?
    @NSManaged public var prepayment: Double
    @NSManaged public var feeShip: Double
    @NSManaged public var status: String?
    @NSManaged public var shipper: Shipper?
    
    
}
