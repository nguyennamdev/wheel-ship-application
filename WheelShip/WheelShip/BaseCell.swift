//
//  BaseCell.swift
//  WheelShip
//
//  Created by Nguyen Nam on 4/21/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class BaseCell : UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupViews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
    
}
