//
//  Authentication.swift
//  WheelShip
//
//  Created by Nguyen Nam on 1/31/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class Authentication{
    
    private init(){}
    static let instance:Authentication = Authentication()
    // MARK: private functions
    
    private func makeRequest(method:String, value:[String:Any], path:String) -> URLRequest?{
        let url = URL(string: "https://wheel-ship.herokuapp.com/users/\(path)")
        var request = URLRequest(url: url!)
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = method
        guard let httpBody = try?JSONSerialization.data(withJSONObject: value, options: []) else {
            return nil
        }
        request.httpBody = httpBody
        return request
    }
    
    // public functions
    public func insertNewUser(value:[String:Any],isComplete:@escaping (Any) -> ()){
        guard let urlRequest = makeRequest(method: "POST", value: value, path: "insert_new_user") else { return }
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error != nil{
                print(error as Any)
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


