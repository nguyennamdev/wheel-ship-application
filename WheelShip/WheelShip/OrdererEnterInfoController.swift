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
    
    // MARK: Properties
    var heightConstaintOfWeightPickerView:NSLayoutConstraint?
    let listWeight = ["0 - 3 kg", "3 - 5 kg", "Trên 5 kg"]
    var weightPickerViewIsShowing = false
    var weightAttributedText:NSMutableAttributedString?
    let orderApiManager = OrderApiManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set background
        view.addSubview(background)
        background.frame = view.frame
    
        // set up navigationItem
        navigationItem.rightBarButtonItem = doneBarButtonItem
        navigationItem.title = "Thêm đơn mới"
        // set up views
        setupPageControl()
        setupPhoneReciverTextField()
        setupFragileObjectView()
        setupWeightContainerView()
        setupPrepaymentTextField()
        setupNoteTextField()
        setupOverheadsStackView()
        setupDividerView()
        // setup weight picker view
        weightPickerView.delegate = self
        weightPickerView.dataSource = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewEndEdit))
        view.addGestureRecognizer(tapGesture)
        
        prepaymentTextField.delegate = self
        
        // func test destinations matrix
        orderApiManager.makeDistanceMatrixRequests(origins: nil, destinations: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidLoad()
        let backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    // MARK: Views
    let background:GradientView = {
        let gv = GradientView()
        gv.colors = [ UIColor.rgb(r: 190, g: 147, b: 197).cgColor,
                      UIColor.rgb(r: 123, g: 198, b: 204).cgColor]
        return gv
    }()
    
    let pageControl:UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 3
        pageControl.currentPage = 1
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    lazy var doneBarButtonItem:UIBarButtonItem = {
        let bt = UIBarButtonItem(title: "Tiếp tục", style: .plain, target: self, action: #selector(showOrderConfirmationController))
        return bt
    }()
    
    let phoneReceiverTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Số điện thoại người nhận"
        tf.setupImageForLeftView(image: #imageLiteral(resourceName: "telephone"))
        tf.keyboardType = .numberPad
        tf.setDefaultWithCustomBoder()
        return tf
    }()
    
    let fragileObjectView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.gray.cgColor
        return view
    }()
    
    let isFragileSwitch:UISwitch = {
        let sw = UISwitch()
        sw.isOn = false
        sw.addTarget(self, action: #selector(isFragileSwitchValueChanged), for: .valueChanged)
        sw.translatesAutoresizingMaskIntoConstraints = false
        return sw
    }()
    
    lazy var weightContainerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.gray.cgColor
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showWeightPicker))
        view.addGestureRecognizer(tapGesture)
        return view
    }()
    
    let weightPickerView:UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = UIColor.white
        picker.isUserInteractionEnabled = true
        return picker
    }()
    
    let weightLabel:UILabel = {
        let label = UILabel()
        label.attributedText = NSAttributedString(string: "Khối lượng : ", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 13), NSAttributedStringKey.foregroundColor : UIColor.gray])
        return label
    }()
    
    let prepaymentTextField:UITextField = {
        let tf = UITextField()
        tf.setDefaultWithCustomBoder()
        tf.placeholder = "Giá tiền ứng trước"
        tf.keyboardType = .numberPad
        tf.setupImageForLeftView(image: #imageLiteral(resourceName: "coin"))
        return tf
    }()
    
    let noteTextField:UITextField = {
        let tf = UITextField()
        tf.setDefaultWithCustomBoder()
        tf.placeholder = "Ghi chú (tên hàng,thời gian,số lượng ...)"
        tf.setupImageForLeftView(image: #imageLiteral(resourceName: "pencil"))
        return tf
    }()
    
    let dividerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
    
    let overheadsStackView:UIStackView = {
        let sv = UIStackView()
        sv.axis = UILayoutConstraintAxis.horizontal
        sv.distribution = .fillEqually
        return sv
    }()
    
    let overheadsLabel:UILabel = {
        let label = UILabel()
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
}

// MARK: Implement functions of UIPickerViewDelegate and DataSource
extension OrdererEnterInfoController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listWeight.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return listWeight[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let result = listWeight[row]
        // get price by row
        var priceOfWeight:Double
        switch row {
        case 0:
            priceOfWeight = 5000
        case 1:
            priceOfWeight = 10000
        case 2:
            priceOfWeight = 15000
        default:
            priceOfWeight = 0
        }
        weightAttributedText = NSMutableAttributedString(string: "Khối lượng : ", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 13), NSAttributedStringKey.foregroundColor : UIColor.gray])
        weightAttributedText?.append(NSAttributedString(string: "\t \t \(result) = \(priceOfWeight.formatedNumberWithUnderDots()) vnđ", attributes: [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 13)]))
        weightLabel.attributedText = weightAttributedText!
    }
}
// MARK: Implement functions of UITextFieldDelegate
extension OrdererEnterInfoController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        prepaymentTextField.resignFirstResponder()
        return true
    }

}











