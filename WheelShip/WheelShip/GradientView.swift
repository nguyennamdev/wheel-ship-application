//
//  GradientView.swift
//  WheelShip
//
//  Created by Nguyen Nam on 1/26/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class GradientView:UIView {
    
    var colors:[CGColor]?{
        didSet{
            updateView()
        }
    }
    
    override class var layerClass: Swift.AnyClass{
        get{
            return CAGradientLayer.self
        }
    }
    
    func updateView(){
        let layer = self.layer as? CAGradientLayer
        layer?.colors = self.colors
    }
    
    
}
