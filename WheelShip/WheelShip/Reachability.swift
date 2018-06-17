//
//  File.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/25/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//
import Foundation
import UIKit
import SystemConfiguration

class Reachability {
    
    static let instance: Reachability = Reachability()
    
    private init(){ }
    
    func currentReachbilityStatus() -> Bool{
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress){
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1){ zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        // working for cellular and wifi
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        let result = (isReachable && !needsConnection)
        return result
    }
    
    func showAlertToSettingInternet() -> UIAlertController{
        let alert = UIAlertController(title: "Dữ liệu di động đã bị tắt", message: "Bật dữ liệu đi động hoặc sử dụng Wi-Fi để truy cập dữ liệu", preferredStyle: .alert)
        let settingAction = UIAlertAction(title: "Cài đặt", style: .default) { (alertAction) in
            guard let url = URL(string: UIApplicationOpenSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alert.addAction(settingAction)
        let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(cancel)
        return alert
    }
    
}
