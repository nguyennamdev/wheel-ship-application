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

    
    var defaultColor:[CGColor] = [ UIColor.rgb(r: 190, g: 147, b: 197).cgColor,
                                    UIColor.rgb(r: 123, g: 198, b: 204).cgColor]
    

    override class var layerClass: Swift.AnyClass{
        get{
            return CAGradientLayer.self
        }
    }
    
    func updateView(){
        let layer = self.layer as? CAGradientLayer
        layer?.colors = self.colors
    }

    func setupDefaultColor(){
        let layer = self.layer as? CAGradientLayer
        layer?.colors = defaultColor
    }
    
 
}
