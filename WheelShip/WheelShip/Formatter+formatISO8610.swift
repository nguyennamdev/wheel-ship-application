//
//  Formatter+formatISO8610.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/24/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Foundation

extension Formatter{
    
    static let iso8610: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
    
}
