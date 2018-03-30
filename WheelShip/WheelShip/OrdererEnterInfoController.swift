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
    let listWeight = ["0 - 3 kg", "3 - 5 kg", "Trên 5 kg"]
    var weightPickerViewIsShowing = false
    var weightAttributedText:NSMutableAttributedString?
    var unitPrice:UnitPrice?{
        didSet{
            updateStateBarButtonItem()
            updateOverheadsLabel()
        }
    }
    var order:Order?{
        didSet{
            self.handleDistanceMatrix()
        }
    }
    
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
        initUnitPrice()
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
    
    private func initUnitPrice(){
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate{
            let context = appDelegate.persistentContainer.viewContext
            self.unitPrice = UnitPrice(context: context)
        }
    }
    
    private func handleDistanceMatrix(){
        guard let origin = order?.originLocation as? CLLocation,let destination = order?.destinationLocation as? CLLocation else { return }
        let origins = "\(origin.coordinate.latitude),\(origin.coordinate.longitude)"
        let destinations = "\(destination.coordinate.latitude),\(destination.coordinate.longitude)"
        let distanceMatrixApiKey = "AIzaSyAnyH3snwD3N3oru00t1cQVp_VgQNHZ5_Y"
        Alamofire.request("https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=\(origins)&destinations=\(destinations)&key=\(distanceMatrixApiKey)").responseJSON { (response) in
            if let json = response.result.value {
                // return tupple distance text and distance value
                let result = self.parseDistanceJson(json: json)
                let distanceText = result.text
                let distanceValue = result.value
                // feeShip = pricePerKl * (distanceValue / 1000)
                self.getPricePerKilometerByApi(isComplete: { (pricePerKilometer) in
                    self.unitPrice?.feeShip = Double(pricePerKilometer * (distanceValue / 1000))
                    guard let feeShip = self.unitPrice?.feeShip, let overheads = self.unitPrice?.overheads else { return }
                    self.setAttributedStringForDistanceLabel(value: distanceText + " = \(feeShip.formatedNumberWithUnderDots()) vnđ")
                    self.updateOverheadsLabel()
                })
            }
        }
    }
    
    private func parseDistanceJson(json:Any) -> (text:String, value:Int){
        var result:String?
        var distanceValue:Int?
        if let jsonData = json as? [String: Any] {
            if let rows = jsonData["rows"] as? [[String : Any]]{
                if let element = rows.first!["elements"] as? [[String : Any]] {
                    if let distance = element.first!["distance"] as? [String : Any] {
                        let text = distance["text"] as! String
                        result = text
                        let value = distance["value"] as! Int
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
    
    private func getPricePerKilometerByApi(isComplete:@escaping (Int) -> ()){
        Alamofire.request("https://wheel-ship.herokuapp.com/orders/price-per-kilometer", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON(completionHandler: { (response) in
            if let json = response.result.value as? [String: Any]{
                if let data = json["data"] as? [[String: Any]]{
                    let priceValue = data.first!["value"] as? Int
                    isComplete(priceValue!)
                }
            }
        })
    }
    
    private func setAttributedStringForDistanceLabel(value:String){
        let attributedString = NSMutableAttributedString(string: "\t Khoảng cách: ", attributes:[NSAttributedStringKey.foregroundColor : UIColor.gray])
        attributedString.append(NSAttributedString(string: value, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 13)]))
        distanceLabel.attributedText = attributedString
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
        switch row {
        case 0:
            self.unitPrice?.priceOfWeight = 5000
        case 1:
            self.unitPrice?.priceOfWeight = 10000
        case 2:
            self.unitPrice?.priceOfWeight = 15000
        default:
            self.unitPrice?.priceOfWeight = 0
        }
        guard let priceOfWeight = self.unitPrice?.priceOfWeight else { return }
        weightAttributedText = NSMutableAttributedString(string: "Khối lượng : ", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 13), NSAttributedStringKey.foregroundColor : UIColor.gray])
        weightAttributedText?.append(NSAttributedString(string: "\t \(result) = \(priceOfWeight.formatedNumberWithUnderDots()) vnđ", attributes: [NSAttributedStringKey.foregroundColor : UIColor.black, NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 13)]))
        weightLabel.attributedText = weightAttributedText!
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
        if textField.isEqual(prepaymentTextField){
            if prepaymentTextField.text != "" {
                guard let value = prepaymentTextField.text else { return }
                self.unitPrice?.prepayment = Double(value)!
                updateOverheadsLabel()
            }
        }
        updateStateBarButtonItem()
    }
    
}











