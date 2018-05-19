//
//  UIViewController+PresentAlert.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/14/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func presentAlertWithTitleAndMessage(title:String, message: String, completion:(() -> Swift.Void)? = nil){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancel)
        present(alert, animated: true, completion: completion)
    }
    
    func presentAlertWithTitleAndMessage(title:String, message:String, action:((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: action)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
}
