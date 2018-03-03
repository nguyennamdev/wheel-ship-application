//
//  HomeOrdererController.swift
//  WheelShip
//
//  Created by Nguyen Nam on 3/3/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import CoreLocation

class HomeOrdererController:UIViewController {
    
    var locationManager:CLLocationManager?
    var fromLocation:CLLocation?{
        didSet{
            convertLocationToAddress(location: fromLocation) { (address) in
                print(address)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Đặt hàng"
        view.addSubview(background)
        background.frame = view.frame
        // setup views
        setupSegmentedControl()
        setupFromAddressTextField()
        setupToAddressTextField()
        setupPriceTextField()
        setupPrepaymentTextField()
        setupPhoneReceiverAddressTextField()
        
        navigationItem.rightBarButtonItem = doneBarButtonItem
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endingEntryText))
        view.addGestureRecognizer(tapGesture)
        textFieldSetDelegate()
        setupCLLocationManager()
        
        
        
    }
    
    // setup views
    
    private func setupSegmentedControl(){
        view.addSubview(addressSegmentedControl)
        addressSegmentedControl.anchorWithWidthHeightConstant(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 24, leftConstant: 48, bottomConstant: 0, rightConstant: 48, widthConstant: 0, heightConstant: 40)
    }
    
    private func setupFromAddressTextField(){
        view.addSubview(fromAddressTextField)
        fromAddressTextField.anchorWithWidthHeightConstant(top: addressSegmentedControl.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 12, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 50)
    }
    
    private func setupToAddressTextField(){
        view.addSubview(toAddressTextField)
        toAddressTextField.anchorWithWidthHeightConstant(top: fromAddressTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 12, leftConstant: 24, bottomConstant: 0, rightConstant: 24, widthConstant: 0, heightConstant: 50)
    }
    
    private func setupPriceTextField(){
        view.addSubview(priceTextField)
        priceTextField.anchorWithWidthHeightConstant(top: nil, left: view.leftAnchor, bottom: view.layoutMarginsGuide.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 24, bottomConstant: 24, rightConstant: 24, widthConstant: 0, heightConstant: 50)
    }
    
    private func setupPrepaymentTextField(){
        view.addSubview(prepaymentTextField)
        prepaymentTextField.anchorWithWidthHeightConstant(top: nil, left: view.leftAnchor, bottom: priceTextField.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 24, bottomConstant: 18, rightConstant: 24, widthConstant: 0, heightConstant: 50)
    }
    
    private func setupPhoneReceiverAddressTextField(){
        view.addSubview(phoneReceiverTextField)
        phoneReceiverTextField.anchorWithWidthHeightConstant(top: nil, left: view.leftAnchor, bottom: prepaymentTextField.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 24, bottomConstant: 18, rightConstant: 24, widthConstant: 0, heightConstant: 50)
    }
    
    
    // functions
    
    private func updateStateDoneBarButton(){
        guard let fromAddress = fromAddressTextField.text ,
            let toAddress = toAddressTextField.text,
            let phoneReceiver = phoneReceiverTextField.text,
            let prepayment = prepaymentTextField.text,
            let price = priceTextField.text else { return }
        switch ""{
        case fromAddress, toAddress, phoneReceiver, prepayment, price:
            doneBarButtonItem.isEnabled = false
        default:
            doneBarButtonItem.isEnabled = true
        }
    }
    
    private func textFieldSetDelegate(){
        fromAddressTextField.delegate = self
        toAddressTextField.delegate = self
        phoneReceiverTextField.delegate = self
        prepaymentTextField.delegate = self
        priceTextField.delegate = self
    }
    
    private func setupCLLocationManager(){
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.requestAlwaysAuthorization()
        DispatchQueue.main.async {
            self.locationManager?.startUpdatingLocation()
        }
    }
    
    
    // views
    let background:GradientView = {
        let gv = GradientView()
        gv.colors = [ UIColor.rgb(r: 190, g: 147, b: 197).cgColor,
                      UIColor.rgb(r: 123, g: 198, b: 204).cgColor]
        return gv
    }()
    
    let addressSegmentedControl:UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Hiện tại", "Địa chỉ khác"])
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    let fromAddressTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Địa chỉ bắt đầu"
        tf.setupDefault()
        tf.setupImageForLeftView(image: #imageLiteral(resourceName: "placeholder"))
        return tf
    }()
    
    let toAddressTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Địa chỉ đến"
        tf.setupDefault()
        tf.setupImageForLeftView(image: #imageLiteral(resourceName: "placeholder2"))
        return tf
    }()
    
    let phoneReceiverTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Số điện thoại người nhận"
        tf.setupDefault()
        tf.setupImageForLeftView(image: #imageLiteral(resourceName: "telephone"))
        tf.keyboardType = .numberPad
        return tf
    }()
    
    let prepaymentTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Tiền ứng trước"
        tf.setupDefault()
        tf.setupImageForLeftView(image: #imageLiteral(resourceName: "coin"))
        tf.keyboardType = .numberPad
        return tf
    }()
    
    let priceTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Phí vận chuyển"
        tf.setupDefault()
        tf.setupImageForLeftView(image: #imageLiteral(resourceName: "coin"))
        tf.keyboardType = .numberPad
        return tf
    }()
    
    lazy var doneBarButtonItem:UIBarButtonItem = {
        let barButton = UIBarButtonItem(title: "Xong", style: .done, target: self, action: #selector(makeNewOrder))
        barButton.isEnabled = false
        return barButton
    }()
}

// implement functions of text field delegate
extension HomeOrdererController : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateStateDoneBarButton()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension HomeOrdererController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.fromLocation = location
        
    }
    
    func convertLocationToAddress(location:CLLocation?, complete:@escaping (String) -> ()){
        guard let location = location else { return }
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            guard let lastPlaceMark = placemarks?.last else { return }
            if let name = lastPlaceMark.name , let country = lastPlaceMark.country, let locality = lastPlaceMark.locality, let subADministrativeArea = lastPlaceMark.subAdministrativeArea{
                let result = "\(name), \(subADministrativeArea), \(locality), \(country)"
                complete(result)
            }
        }
    }
}


















