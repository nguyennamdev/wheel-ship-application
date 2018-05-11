//
//  EditOrderViewController.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/10/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import Alamofire
import GooglePlaces


class EditOrderViewController: UIViewController {
    
    // MARK: Views
    @IBOutlet weak var backgroundView: GradientView!
    @IBOutlet weak var phoneReceiverTextField: UITextField!
    @IBOutlet weak var destinationAddressTextField: UITextField!
    @IBOutlet weak var originAddressTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var prepaymentTextField: UITextField!
    @IBOutlet weak var noteTextField: UITextField!
    @IBOutlet weak var orderFragileSwitch: UISwitch!
    @IBOutlet weak var feeShipLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var priceOfOrderFragileLabel: UILabel!
    @IBOutlet weak var priceOfWeightLabel: UILabel!
    @IBOutlet weak var overheadsLabel: UILabel!
    var previousButton:UIBarButtonItem?
    var nextButton:UIBarButtonItem?
    var updateBarButtonItem:UIBarButtonItem?
    
    // MARK: Properties
    var orderIdToEdit:String?
    var arrTextField:[UITextField]?
    var priceOfWeightPicker:UIPickerView = UIPickerView()
    var currentTextFieldIsShowing:Int = 0
    var priceFragileOrder:Double = 0 {
        didSet{
            if orderFragileSwitch.isOn {
                self.priceOfOrderFragileLabel.attributedText = NSAttributedString(string: "\(priceFragileOrder.formatedNumberWithUnderDots()) vnđ", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16)])
            }else{
                  self.priceOfOrderFragileLabel.attributedText = NSAttributedString(string: "0 vnđ", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16)])
            }
        }
    }
    var order:Order = Order()
    var autocompleteViewController:GMSAutocompleteViewController?
    var arrWeightPrice:[Price] = [Price]()
    
    // MARK: Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation item
        self.navigationItem.title = "Chỉnh sửa đơn hàng"
        customRightBarButtonItem()
        backgroundView.setupDefaultColor()
        
        setupTextFields()
        // set datasource and delegate for picker view
        priceOfWeightPicker.dataSource = self
        priceOfWeightPicker.delegate = self
        // text fields
        initToolBarForTextField()
        
        // call apis
        callApiToGetOrderById()
        callApiToGetListPriceWeight()
        callApiToGetPriceFragileOrder()
        callApiToGetPriceDistance()
        
        // init auto complete place
        autocompleteViewController = GMSAutocompleteViewController()
        autocompleteViewController?.delegate = self
        
    }
    // MARK: Public functions
    
    func updateOverheadsLabel(){
        guard let overheads = self.order.unitPrice?.overheads else {
            return
        }
        self.overheadsLabel.setAttitudeString(content: ("\(overheads.formatedNumberWithUnderDots())", UIColor.black, UIFont.boldSystemFont(ofSize: 16)))
    }
    
    func updateStateBarButton(){
        if originAddressTextField.text == "" || destinationAddressTextField.text == "" || phoneReceiverTextField.text == "" || weightTextField.text == "" || prepaymentTextField.text == "" || noteTextField.text == ""{
            updateBarButtonItem?.isEnabled = false
        }else{
            updateBarButtonItem?.isEnabled = true
        }
    }
    
    // MARK: Private funcions
  
    private func customRightBarButtonItem(){
        updateBarButtonItem = UIBarButtonItem(title: "Xong", style: .done, target: self, action: #selector(updateOrder))
        updateBarButtonItem?.isEnabled = false
        self.navigationItem.rightBarButtonItem = updateBarButtonItem
        
    }
    
    // MARK: Call api to get data
    private func callApiToGetOrderById(){
        guard let orderId = self.orderIdToEdit else {
            return
        }
        Alamofire.request("https://wheel-ship.herokuapp.com/orders/order_by_orderId", method: .get
            , parameters: ["orderId": orderId], encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
                if let value = response.result.value as? NSDictionary{
                    if let data = value.value(forKey: "data") as? NSDictionary{
                        self.order.setValueByNSDictionary(dictionary: data)
                        DispatchQueue.main.async {
                            self.loadOrderData(order: self.order)
                        }
                    }
                }
        }
    }
    
    private func loadOrderData(order:Order){
        guard let unitPrice = order.unitPrice else {
            return
        }
        originAddressTextField.text = order.originAddress
        destinationAddressTextField.text = order.destinationAddress
        phoneReceiverTextField.text = order.phoneReceiver
        weightTextField.text = order.weight
        prepaymentTextField.text = "\(unitPrice.prepayment)"
        noteTextField.text = order.note
        order.isFragile == true ? (orderFragileSwitch.setOn(true, animated: true)) : (orderFragileSwitch.setOn(false, animated: true))
        distanceLabel.setAttitudeString(content: ("\(order.distance!.formatedNumberWithUnderDots()) km", UIColor.black, UIFont.boldSystemFont(ofSize: 16)))
        feeShipLabel.setAttitudeString(content: ("\(unitPrice.feeShip.formatedNumberWithUnderDots()) vnđ", UIColor.black, UIFont.boldSystemFont(ofSize: 16)))
        priceOfWeightLabel.setAttitudeString(content: ("\(unitPrice.priceOfWeight!.formatedNumberWithUnderDots()) vnđ", UIColor.black, UIFont.boldSystemFont(ofSize: 16)))
        overheadsLabel.setAttitudeString(content: ("\(unitPrice.overheads.formatedNumberWithUnderDots()) vnd", UIColor.black, UIFont.boldSystemFont(ofSize: 16)))
    }

    private func callApiToGetListPriceWeight(){
        Alamofire.request("https://wheel-ship.herokuapp.com/prices/price_weights", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let result = response.result.value as? [String: Any]{
                if let data = result["data"] as? [[String: Any]]{
                    data.forEach({ (element) in
                        let price = Price()
                        price.setValueWithKey(value: element)
                        self.arrWeightPrice.append(price)
                    })
                    self.priceOfWeightPicker.reloadAllComponents()
                }
            }
        }
    }
    
    private func callApiToGetPriceFragileOrder(){
        Alamofire.request("https://wheel-ship.herokuapp.com/prices/price_fragile_order", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let result = response.result.value as? [String:Any]{
                if let data = result["data"] as? [[String: Any]]{
                    let priceFragileOrder = data.first?["value"] as! Double
                    self.priceFragileOrder = priceFragileOrder
                }
            }
        }
    }
  
    private func callApiToGetPriceDistance(){
        Alamofire.request("https://wheel-ship.herokuapp.com/prices/price_distance", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let result = response.result.value as? [String:Any]{
                if let data = result["data"] as? [[String: Any]]{
                    let price = Price()
                    price.setValueWithKey(value: data.first!)
                    self.order.unitPrice?.priceOfDistance = price
                }
            }
        }
    }
    
    // MARK: set up text fields
    private func setupTextFields(){
        self.arrTextField = [originAddressTextField, destinationAddressTextField, phoneReceiverTextField, weightTextField, prepaymentTextField, noteTextField]
        // set delegate
        for textField:UITextField in self.arrTextField! {
            textField.delegate = self
        }
    }
    
    private func initToolBarForTextField(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        // set up bar button item on tool bar
        previousButton = UIBarButtonItem(image: #imageLiteral(resourceName: "up-arrow") , style: .plain, target: self, action: #selector(handleBackToPreviousButton))
        previousButton?.tintColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        nextButton = UIBarButtonItem(image: #imageLiteral(resourceName: "drop-down-arrow"), style: .plain, target: self, action: #selector(handleNextToNextButton))
        nextButton?.tintColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [previousButton!, space, nextButton!]
        // set up input accessory view
        textFieldsSetInputAccessoryView(toolBar: toolBar)
        setupWeightTextField()
    }
    
    private func textFieldsSetInputAccessoryView(toolBar:UIToolbar) {
        originAddressTextField.inputAccessoryView = toolBar
        destinationAddressTextField.inputAccessoryView = toolBar
        phoneReceiverTextField.inputAccessoryView = toolBar
        prepaymentTextField.inputAccessoryView = toolBar
        noteTextField.inputAccessoryView = toolBar
    }
    
    private func setupWeightTextField(){
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        // set up bar button item on tool bar
        previousButton = UIBarButtonItem(image: #imageLiteral(resourceName: "up-arrow") , style: .plain, target: self, action: #selector(handleBackToPreviousButton))
        previousButton?.tintColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        
        nextButton = UIBarButtonItem(image: #imageLiteral(resourceName: "drop-down-arrow"), style: .plain, target: self, action: #selector(handleNextToNextButton))
        nextButton?.tintColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
        
        let doneButton = UIBarButtonItem(title: "done", style: .done, target: self, action: #selector(completeSelectWeight))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.items = [previousButton!, nextButton!, space, doneButton]
        // weightTextField set input view and accessory view
        weightTextField.inputView = priceOfWeightPicker
        weightTextField.inputAccessoryView = toolBar
    }
    
    
    // MARK: Actions
    @IBAction func orderFragileValueChanged(_ sender: UISwitch) {
        if sender.isOn {
            self.order.unitPrice?.priceFragileOrder = priceFragileOrder
        }else {
            self.order.unitPrice?.priceFragileOrder = 0
        }
        if let price = self.order.unitPrice?.priceFragileOrder {
            self.priceOfOrderFragileLabel.attributedText = NSAttributedString(string: "\(price.formatedNumberWithUnderDots()) vnđ", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16)])
        }
        self.updateOverheadsLabel()
    }
    
    @objc private func handleBackToPreviousButton(){
        currentTextFieldIsShowing = currentTextFieldIsShowing - 1
        if (currentTextFieldIsShowing < 0){
            currentTextFieldIsShowing = 0
        }
        // show text field at currentTextFieldIsShowing index
        self.arrTextField?[currentTextFieldIsShowing].becomeFirstResponder()
    }
    
    @objc private func handleNextToNextButton(){
        currentTextFieldIsShowing = currentTextFieldIsShowing + 1
        if (currentTextFieldIsShowing > (self.arrTextField?.count)! - 1){
            currentTextFieldIsShowing = (self.arrTextField?.count)! - 1
        }
        // show text field at currentTextFieldIsShowing index
        self.arrTextField?[currentTextFieldIsShowing].becomeFirstResponder()
    }
    
    @objc private func completeSelectWeight(){
        weightTextField.resignFirstResponder()
    }
    
    @objc private func updateOrder(){
        
    }
    
}

// MARK: Implement UITextFieldDelegate
extension EditOrderViewController : UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.currentTextFieldIsShowing = textField.tag
        // hide previous button when currentTextFieldIsShowing = 0
        currentTextFieldIsShowing == 0 ? (self.previousButton?.isEnabled = false) : (self.previousButton?.isEnabled = true)
        // hide next button when currentTextFieldIsShowing out range text fields
        currentTextFieldIsShowing == (self.arrTextField?.count)! - 1 ? (self.nextButton?.isEnabled = true) : (self.nextButton?.isEnabled = true)
        
        if textField.isEqual(originAddressTextField) || textField.isEqual(destinationAddressTextField){
            present(autocompleteViewController!, animated: true, completion: nil)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateStateBarButton()
    }
}

// MARK: Implement UIPickerViewDatasource and UIPickerViewDelegate
extension EditOrderViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrWeightPrice.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.arrWeightPrice[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.weightTextField.text = self.arrWeightPrice[row].name
        self.order.unitPrice?.priceOfWeight = self.arrWeightPrice[row].value
        self.priceOfWeightLabel.setAttitudeString(content: ("\(self.order.unitPrice?.priceOfWeight?.formatedNumberWithUnderDots() ?? "0") vnđ", UIColor.black, UIFont.boldSystemFont(ofSize: 16)))
        self.updateOverheadsLabel()
    }
    
}
































