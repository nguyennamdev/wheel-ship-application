//
//  OrderApiManager.swift
//  WheelShip
//
//  Created by Nguyen Nam on 3/21/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Foundation
import CoreLocation

class OrderApiManager {
    
    private init() {}
    static let shared:OrderApiManager = OrderApiManager()
    let distanceMatrixApiKey = "AIzaSyAnyH3snwD3N3oru00t1cQVp_VgQNHZ5_Y"
    
    public func makeDistanceMatrixRequests(originLocation:CLLocation?,destinationLocation:CLLocation?, isComplete:@escaping (Any) -> ()){
        let origins = "\(String(describing: originLocation?.coordinate.latitude)),\(String(describing: originLocation?.coordinate.longitude))"
        let destinations = "\(String(describing: destinationLocation?.coordinate.latitude)),\(String(describing: destinationLocation?.coordinate.longitude))"
        let url = URL(string: "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=\(origins)&destinations=\(destinations)&key=\(distanceMatrixApiKey)")
        if url != nil{
            let task = URLSession.shared.dataTask(with: URLRequest(url: url!)) { (data, response, error) in
                if error != nil{
                    return
                }
                guard let jsonData = data else{ return }
                do{
                    if let json = try?JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers){
                        isComplete(json)
                    }
                }
            }
            task.resume()
        }
    }
}
