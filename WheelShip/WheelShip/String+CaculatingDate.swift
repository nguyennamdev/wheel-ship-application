//
//  String+CaculatingDate.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/24/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import Foundation

extension String {

    func caculatingDatePassedWithCurrentDate() -> String{
          var result:String = ""
        let dateString = self
        let passedDate = Formatter.iso8610.date(from: dateString)
        let currentDate = Date()
        // get time between passedDate and currentDate
        if passedDate != nil {
            let diffDateComponents = Calendar.current.dateComponents([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day, Calendar.Component.hour, Calendar.Component.minute], from:passedDate!, to: currentDate)
            if diffDateComponents.year != 0 {
                result += "\(diffDateComponents.year!) năm "
            }
            if diffDateComponents.month != 0{
                result += "\(diffDateComponents.month!) tháng "
            }
            if diffDateComponents.day != 0 {
                result += "\(diffDateComponents.day!) ngày "
            }
            if diffDateComponents.hour != 0 {
                result += "\(diffDateComponents.hour!) giờ "
            }
            if diffDateComponents.minute != 0{
                result += "\(diffDateComponents.minute!) phút"
            }else{
                result = "vừa xong"
            }
        }
        return result
    }

}
