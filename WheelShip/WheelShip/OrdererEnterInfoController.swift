//
//  OrdererEnterInforController.swift
//  WheelShip
//
//  Created by Nguyen Nam on 3/12/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Foundation
import UIKit

class OrdererEnterInfoController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set background
        view.addSubview(background)
        background.frame = view.frame
        
        setupPageControl()
        
    }
    
    
    // MARK : Views
    
    let background:GradientView = {
        let gv = GradientView()
        gv.colors = [ UIColor.rgb(r: 190, g: 147, b: 197).cgColor,
                      UIColor.rgb(r: 123, g: 198, b: 204).cgColor]
        return gv
    }()
    
    let pageControl:UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 2
        pageControl.currentPage = 1
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
}
