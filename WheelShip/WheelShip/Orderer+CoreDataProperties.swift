//
//  Orderer+CoreDataProperties.swift
//  WheelShip
//
//  Created by Nguyen Nam on 2/4/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//
//

import Foundation
import CoreData


extension Orderer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Orderer> {
        return NSFetchRequest<Orderer>(entityName: "Orderer")
    }

    @NSManaged public var orders: NSSet?

}

// MARK: Generated accessors for orders
extension Orderer {

    @objc(addOrdersObject:)
    @NSManaged public func addToOrders(_ value: Order)

    @objc(removeOrdersObject:)
    @NSManaged public func removeFromOrders(_ value: Order)

    @objc(addOrders:)
    @NSManaged public func addToOrders(_ values: NSSet)

    @objc(removeOrders:)
    @NSManaged public func removeFromOrders(_ values: NSSet)

}
