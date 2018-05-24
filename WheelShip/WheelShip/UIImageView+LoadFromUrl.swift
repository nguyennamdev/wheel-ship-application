//
//  UIImageView+LoadFromUrl.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/23/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

extension UIImageView{
    
    func loadImageFromUrl(urlString:String){
        let url = URL(string: urlString)
        do{
            let data = try Data(contentsOf: url!)
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }catch {
            print(error)
        }
    }
    
}
