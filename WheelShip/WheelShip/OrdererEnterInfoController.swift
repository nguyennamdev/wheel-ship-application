//
//  OrdererEnterInforController.swift
//  WheelShip
//
//  Created by Nguyen Nam on 3/12/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire


class OrdererEnterInfoController : UIViewController {
    
    // MARK: Properties
    var heightConstaintOfWeightPickerView:NSLayoutConstraint?
    var weightPickerViewIsShowing = false
    var weightAttributedText:NSMutableAttributedString?
    var dummyPriceFragileOder:Double = 0
    var unitPrice:UnitPrice?{
        didSet{
            updateStateBarButtonItem()
            updateOverheadsLabel()
        }
    }
    var order:Order?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set background
        view.addSubview(background)
        background.frame = view.frame
        // set up navigationItem
        navigationItem.rightBarButtonItem = doneBarButtonItem
        navigationItem.title = "Thêm đơn mới"
        // set up views
        setupViews()
        // setup weight picker view
        weightPickerView.delegate = self
        weightPickerView.dataSource = self
        ////////
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewEndEdit))
        view.addGestureRecognizer(tapGesture)
        ////////
        noteTextField.delegate = self
        prepaymentTextField.delegate = self
        phoneReceiverTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        callApiToGetPriceFragileOrder()
        handleDistanceMatrix()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidLoad()
        let backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backBarButtonItem
    }
    
    
    // MARK: Private functions
    private func setupViews(){
        setupPageControl()
        setupPhoneReciverTextField()
        setupFragileObjectView()
        setupWeightContainerView()
        setupPrepaymentTextField()
        setupNoteTextField()
        setupOverheadsStackView()
        setupDividerView()
        setupDistanceLabel()
    }
    
    private func callApiToGetPriceFragileOrder(){
        Alamofire.request("https://wheel-ship.herokuapp.com/prices/price_fragile_order", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let result = response.result.value as? [String:Any]{
                if let data = result["data"] as? [[String: Any]]{
                    let priceFragileOrder = data.first?["value"] as! Double
                    self.dummyPriceFragileOder = priceFragileOrder
                    DispatchQueue.main.async {
                        self.priceFragileLabel.setAttitudeString(title: ("Hàng dễ vỡ : \t", UIColor.gray), content: ("+\(priceFragileOrder.formatedNumberWithUnderDots())", UIColor.black, UIFont.boldSystemFont(ofSize: 13)))
                    }
                }
            }
        }
    }
    
    private func handleDistanceMatrix(){
        guard let origin = order?.originLocation, let destination = order?.destinationLocation else { return }
        let origins = "\(origin.coordinate.latitude),\(origin.coordinate.longitude)"
        let destinations = "\(destination.coordinate.latitude),\(destination.coordinate.longitude)"
        let distanceMatrixApiKey = "AIzaSyAnyH3snwD3N3oru00t1cQVp_VgQNHZ5_Y"
        Alamofire.request("https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=\(origins)&destinations=\(destinations)&key=\(distanceMatrixApiKey)").responseJSON { (response) in
            if let json = response.result.value {
                // return tupple distance text and distance value
                let result = self.parseDistanceJson(json: json)
                let distanceText = result.text
                let distanceValue = result.value
                guard let priceDistance = self.unitPrice?.priceOfDistance?.value else { return }
                self.unitPrice?.feeShip = Double(priceDistance * (distanceValue / 1000))
                self.order?.distance = distanceValue
                if let feeShip = self.unitPrice?.feeShip {
                    self.distanceLabel.setAttitudeString(title: ("\t Khoảng cách: ", UIColor.gray), content: (distanceText + " = \(feeShip.formatedNumberWithUnderDots()) vnđ", UIColor.black, UIFont.boldSystemFont(ofSize: 13)))
                    self.updateOverheadsLabel()
                }
            }
        }
    }
    
    private func parseDistanceJson(json:Any) -> (text:String, value:Double){
        var result:String?
        var distanceValue:Double?
        if let jsonData = json as? [String: Any] {
            if let rows = jsonData["rows"] as? [[String : Any]]{
                if let element = rows.first!["elements"] as? [[String : Any]] {
                    if let distance = element.first!["distance"] as? [String : Any] {
                        let text = distance["text"] as! String
                        result = text
                        let value = distance["value"] as! Double
                        distanceValue = value
                    }
                    if let duration = element.first!["duration"] as? [String : Any] {
                        let text = duration["text"]  as! String
                        result?.append(" - \(text)")
                    }
                }
            }
        }
        return (result!, distanceValue!)
    }
    
    
    private func updateStateBarButtonItem(){
        if let feeShip =  self.unitPrice?.feeShip, let priceOfWeight = self.unitPrice?.priceOfWeight, let prepayment = self.unitPrice?.prepayment{
            switch Double(0){
            case feeShip,priceOfWeight,prepayment :
                doneBarButtonItem.isEnabled = false
            default:
                guard let phoneNumber = phoneReceiverTextField.text, let note = noteTextField.text else { return }
                switch "" {
                case phoneNumber, note:
                    doneBarButtonItem.isEnabled = false
                default:
                    doneBarButtonItem.isEnabled = true
                }
            }
        }
        
    }
    
    // MARK: Public functions
    public func updateOverheadsLabel(){
        guard let overheads = self.unitPrice?.overheads else {
            return
        }
        self.overheadsLabel.text = "\(overheads.formatedNumberWithUnderDots()) vnđ"
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
        let bt = UIBarButtonItem(title: "Tiếp", style: .plain, target: self, action: #selector(showOrderConfirmationController))
        bt.isEnabled = false
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
    
    let distanceLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.backgroundColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let priceFragileLabel:UILabel = {
        let label = UILabel()
        return label
    }()
}

// MARK: Implement functions of UIPickerViewDelegate and DataSource
extension OrdererEnterInfoController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.unitPrice?.listPriceOfWeight?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.unitPrice?.listPriceOfWeight?[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let result = self.unitPrice?.listPriceOfWeight?[row].name
        self.order?.weight = result;
        self.unitPrice?.priceOfWeight = self.unitPrice?.listPriceOfWeight?[row].value
        guard let priceOfWeight = self.unitPrice?.priceOfWeight else { return }
        // set attributed text
        weightLabel.setAttitudeString(title: ("Khối lượng : ", UIColor.gray), content: ("\t \(result ?? "") = \(priceOfWeight.formatedNumberWithUnderDots()) vnđ", UIColor.black, UIFont.boldSystemFont(ofSize: 13)))
        updateOverheadsLabel()
    }
}
// MARK: Implement functions of UITextFieldDelegate
extension OrdererEnterInfoController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField {
        case prepaymentTextField:
            if prepaymentTextField.text != "" {
                guard let value = prepaymentTextField.text else { return }
                self.unitPrice?.prepayment = Double(value)!
                updateOverheadsLabel()
            }
        case noteTextField:
            if noteTextField.text != ""{
                guard let text = noteTextField.text else { return }
                self.order?.note = text;
            }
        case phoneReceiverTextField:
            if phoneReceiverTextField.checkTextIsPhoneNumber(){
                guard let text = phoneReceiverTextField.text else { return }
                self.order?.phoneReceiver = text;
            }else{
                let alertDialog = UIAlertController(title: "Nhập số điện thoại", message: "Số điện thoại của bạn nhập không hợp lệ", preferredStyle: .alert)
                let actionAlert = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                alertDialog.addAction(actionAlert)
                present(alertDialog, animated: true, completion: {
                    self.phoneReceiverTextField.text = ""
                })
            }
        default:
            break
        }
        
        
        updateStateBarButtonItem()
    }
    
}











