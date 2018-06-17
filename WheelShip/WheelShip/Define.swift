//
//  Define.swift
//  WheelShip
//
//  Created by Nguyen Nam on 4/30/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class Define: NSObject {

    static let SHIPPER                  = "Shipper"
    static let ORIGIN_ADDRESS           = "Điểm lấy hàng"
    static let DESTINATION_ADDRESS      = "Điểm giao hàng"
    static let STATUS                   = "Trạng thái"
    static let STATUS_WAIT              = "Chưa có người nhận"
    static let STATUS_WAIT_REPONSE      = "Chờ phản hồi"
    static let PHONE_ORDERER            = "SĐT người đặt hàng"
    static let NOTE                     = "Ghi chú           "
    static let ORDER_FRAGILE_STRING     = "Hàng dễ vỡ        "
    static let OVERHEADS                = "Tổng phí          "
    static let WEIGHT_STRING            = "Khối lượng        "
    static let PHONE_RECEIVER           = "SĐT người nhận    "
    static let PREPAYMENT               = "Tiền ứng trước    "
    static let PRICE_OF_WEIHGT          = "Phí khối lượng    "
    static let PRICE_OF_ORDER_FRAGILE   = "Phí hàng dễ vỡ    "
    static let FEESHIP                  = "Phí vận chuyển    "
    static let STATUS_HAD_SHIPPER       = "Đơn hàng của bạn"
    static let ORDER_ID                 = "Mã vận chuyển "
    static let DISTANCE_STRING          = "Khoảng cách       "
//    static let URL =  "http://localhost:3000"
    static let URL = "https://wheel-ship.herokuapp.com"
    
    static let SHIPPER_REQUEST_STRING = "Đã yêu cầu bạn cho phép vận chuyển đơn hàng"
    static let SHIPPER_GET_RESPONSE_STRING = "Đã cho đồng ý cho bạn vận chuyển đơn hàng"
    
}
