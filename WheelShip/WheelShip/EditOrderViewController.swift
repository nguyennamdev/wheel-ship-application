//
//  EditOrderViewController.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/10/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit
import Alamofire

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
    
    // MARK: Properties
    var orderIdToEdit:String?
    var unitPrice:UnitPrice?
    var arrTextField:[UITextField]?
    var priceOfWeightPicker:UIPickerView = UIPickerView()
    var currentTextFieldIsShowing:Int = 0
    var priceFragileOrder:Double = 0 {
        didSet{
            if orderFragileSwitch.isOn {
                self.priceOfOrderFragileLabel.attributedText = NSAttributedString(string: "\(priceFragileOrder.formatedNumberWithUnderDots())", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16)])
            }
        }
    }
    
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
        callApiToGetListPriceWeight()
        callApiToGetPriceFragileOrder()
        
        loadOrderToUpdate()
       
    }
    
    // MARK: Private funcions
    private func loadOrderToUpdate(){
        
    }
    
    private func customRightBarButtonItem(){
        let editBarButtonItem = UIBarButtonItem(title: "Xong", style: .done, target: self, action: #selector(updateOrder))
        self.navigationItem.rightBarButtonItem = editBarButtonItem
    }
    
    // MARK: call api to get data
    private func callApiToGetListPriceWeight(){
        unitPrice = UnitPrice()
        Alamofire.request("https://wheel-ship.herokuapp.com/prices/price_weights", method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if let result = response.result.value as? [String: Any]{
                if let data = result["data"] as? [[String: Any]]{
                    var prices = [Price]()
                    data.forEach({ (element) in
                        let price = Price()
                        price.setValueWithKey(value: element)
                        prices.append(price)
                    })
                    self.unitPrice?.listPriceOfWeight = prices
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
        // 
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
            unitPrice?.priceFragileOrder = priceFragileOrder
        }else {
            unitPrice?.priceFragileOrder = 0
        }
        if let price = self.unitPrice?.priceFragileOrder {
              self.priceOfOrderFragileLabel.attributedText = NSAttributedString(string: "\(price.formatedNumberWithUnderDots())", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16)])
        }
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
    }
    
}

// MARK: Implement UIPickerViewDatasource and UIPickerViewDelegate
extension EditOrderViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        self.weightTextField.text = self.unitPrice?.listPriceOfWeight?[row].name
    }
    
}
































