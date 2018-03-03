//
//  Location+CoreDataProperties.swift
//  WheelShip
//
//  Created by Nguyen Nam on 2/4/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var lattitude: Double
    @NSManaged public var longtitude: Double

}
