//
//  File.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/7/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

extension UICollectionView {
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = UIColor.white
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.boldSystemFont(ofSize: 24)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
    }
    
    func restore() {
        self.backgroundView = nil
    }
    
}
