//
//  User+CoreDataProperties.swift
//  WheelShip
//
//  Created by Nguyen Nam on 2/4/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//
//

import Foundation
import CoreData


extension User {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }
    @NSManaged public var uid: String?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var password: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var isActive: Int16
    @NSManaged public var isShipper: Int16

}
