//
//  UnitPrice+CoreDataProperties.swift
//  WheelShip
//
//  Created by Nguyen Nam on 3/30/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//
//

import Foundation
import CoreData


extension UnitPrice {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UnitPrice> {
        return NSFetchRequest<UnitPrice>(entityName: "UnitPrice")
    }

    @NSManaged public var prepayment: Double
    @NSManaged public var priceOfWeight: Double
    @NSManaged public var feeShip: Double
    @NSManaged public var priceFragileOrder: Double
    @NSManaged public var order: Order?
    
    public var overheads:Double {
        return feeShip + prepayment + priceFragileOrder + priceOfWeight
    }

}
