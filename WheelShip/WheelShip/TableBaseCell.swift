//
//  TableBaseCell.swift
//  WheelShip
//
//  Created by Nguyen Nam on 5/21/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var order:Order?{
        didSet{
            guard let order = self.order,
                let unitPrice = order.unitPrice,
                let priceFragileOrder = unitPrice.priceFragileOrder else { return }
            // Assign data for labels
            setValueStatusLabeL(order: order)
            stopTime.text = order.stopTime
            originAddressLabel.setAttitudeString(title: (Define.ORIGIN_ADDRESS, #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), content: (" \(order.originAddress ?? "")", UIColor.black))
            destinationLabel.setAttitudeString(title: (Define.DESTINATION_ADDRESS,  #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), content: (" \(order.destinationAddress ?? "")", UIColor.black))
            phoneOrdererLabel.setAttitudeString(title: (Define.PHONE_ORDERER, #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), content: ("\t\(order.phoneOrderer ?? "")", UIColor.black))
            phoneReceiverLabel.setAttitudeString(title: (Define.PHONE_RECEIVER, #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), content: ("\t\(order.phoneReceiver ?? "")", UIColor.black))
            weightLabel.setAttitudeString(title: (Define.WEIGHT_STRING, #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), content: ("\t\(order.weight ?? "")", UIColor.black))
            prepaymentLabel.setAttitudeString(title: (Define.PREPAYMENT, #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), content: ("\t\(unitPrice.prepayment.formatedNumberWithUnderDots()) vnđ", UIColor.black))
            feeShipLabel.setAttitudeString(title: (Define.FEESHIP, #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), content: ("\t\(unitPrice.feeShip.formatedNumberWithUnderDots()) vnđ", UIColor.black))
            priceOfOrderFragileLabel.setAttitudeString(title: (Define.PRICE_OF_ORDER_FRAGILE, #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), content: ("\t\(priceFragileOrder.formatedNumberWithUnderDots()) vnđ", UIColor.black))
            noteLabel.setAttitudeString(title: (Define.NOTE, #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), content: ("\t\(order.note ?? "")", UIColor.black))
        }
    }
    
    // MARK: set value for labels
    func setValueStatusLabeL(order:Order){
        switch order.status! {
        case OrderStage.waitingShipper:
            statusOrderLabel.setAttitudeString(title: (Define.STATUS, #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), content: (" \(Define.STATUS_WAIT)", UIColor.black))
        case OrderStage.waitingResponse:
            statusOrderLabel.setAttitudeString(title: (Define.STATUS, #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), content:(" \(Define.STATUS_WAIT_REPONSE)", #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)))
        case OrderStage.hadShipper:
            statusOrderLabel.setAttitudeString(title: (Define.STATUS, #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), content:(" \(Define.STATUS_HAD_SHIPPER)", UIColor.red))
        }
    }
    
    func setupViews(){
        setupStopTimeLabel()
        setupSeparatorView()
        setupStatusLabel()
        setupOriginAddressLabel()
        setupDestinationLabel()
        setupPhoneOrdererLabel()
        setupPhoneReceiverLabel()
        setupWeightLabel()
        setupPrepaymentLabel()
        setupFeeShipLabel()
        setupPriceOrderFragileLabel()
        setupNoteLabel()
    }
    
    func configurationImage(imageName:String, to imageView:UIImageView){
        imageView.image = UIImage(named: imageName)?.resizeImage(newSize: CGSize(width: 18, height: 18))
    }
    
    func layoutImageView(topAnchor: UIView, imageName:String, to imageView:UIImageView){
        self.addSubview(imageView)
        imageView.anchorWithWidthHeightConstant(top: topAnchor.bottomAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 10, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 18, heightConstant: 18)
        configurationImage(imageName: imageName, to: imageView)
    }
    
    // MARK: setup views
    
    func setupStopTimeLabel(){
        self.addSubview(stopTime)
        stopTime.anchorWithConstants(top: self.topAnchor, left: nil, bottom: nil, right: self.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 8)
        stopTime.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
    
    func setupStatusLabel(){
        self.addSubview(statusOrderLabel)
        statusOrderLabel.anchorWithConstants(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, topConstant: 4, leftConstant: 8, bottomConstant: 0, rightConstant: 0)
    }
    
    func setupSeparatorView(){
        self.addSubview(separatorView)
        separatorView.anchorWithConstants(top: nil, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor)
        separatorView.heightAnchor.constraint(equalToConstant: 5).isActive = true
    }
    
    func setupOriginAddressLabel(){
        layoutImageView(topAnchor: stopTime, imageName: "placeholder", to: originImageView)
        self.addSubview(originAddressLabel)
        originAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        originAddressLabel.centerYAnchor.constraint(equalTo: originImageView.centerYAnchor).isActive = true
        originAddressLabel.leftAnchor.constraint(equalTo: originImageView.rightAnchor, constant: 8).isActive = true
        originAddressLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        originAddressLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
    
    func setupDestinationLabel(){
        layoutImageView(topAnchor: originAddressLabel, imageName: "placeholder2", to: destinationImageView)
        self.addSubview(destinationLabel)
        destinationLabel.anchorWithConstants(top: nil, left: destinationImageView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
        destinationLabel.centerYAnchor.constraint(equalTo: destinationImageView.centerYAnchor).isActive = true
        destinationLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
    
    func setupPhoneOrdererLabel(){
        layoutImageView(topAnchor: destinationLabel, imageName: "telephone", to: phoneOrdererImageView)
        self.addSubview(phoneOrdererLabel)
        phoneOrdererLabel.anchorWithConstants(top: nil, left: phoneOrdererImageView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
        phoneOrdererLabel.centerYAnchor.constraint(equalTo: phoneOrdererImageView.centerYAnchor).isActive = true
        phoneOrdererLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
    }
    
    func setupPhoneReceiverLabel(){
        layoutImageView(topAnchor: phoneOrdererLabel, imageName: "telephone", to: phoneReceiverImageView)
        self.addSubview(phoneReceiverLabel)
        phoneReceiverLabel.anchorWithConstants(top: nil, left: phoneReceiverImageView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
        phoneReceiverLabel.centerYAnchor.constraint(equalTo: phoneReceiverImageView.centerYAnchor).isActive = true
        phoneReceiverLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
    }
    
    func setupWeightLabel(){
        layoutImageView(topAnchor: phoneReceiverLabel, imageName: "weight", to: weightImageView)
        self.addSubview(weightLabel)
        weightLabel.anchorWithConstants(top: nil, left: weightImageView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
        weightLabel.centerYAnchor.constraint(equalTo: weightImageView.centerYAnchor).isActive = true
        weightLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
    }
    
    func setupPrepaymentLabel(){
        layoutImageView(topAnchor: weightLabel, imageName: "coin", to: prepaymentImageView)
        self.addSubview(prepaymentLabel)
        prepaymentLabel.anchorWithConstants(top: nil, left: prepaymentImageView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
        prepaymentLabel.centerYAnchor.constraint(equalTo: prepaymentImageView.centerYAnchor).isActive = true
        prepaymentLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
    }
    
    func setupFeeShipLabel(){
        layoutImageView(topAnchor: prepaymentLabel, imageName: "coin", to: feeShipImageView)
        self.addSubview(feeShipLabel)
        feeShipLabel.anchorWithConstants(top: nil, left: feeShipImageView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
        feeShipLabel.centerYAnchor.constraint(equalTo: feeShipImageView.centerYAnchor).isActive = true
        feeShipLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
    }
    
    func setupPriceOrderFragileLabel(){
        layoutImageView(topAnchor: feeShipLabel, imageName: "coin", to: priceImageView)
        self.addSubview(priceOfOrderFragileLabel)
        priceOfOrderFragileLabel.anchorWithConstants(top: nil, left: priceImageView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
        priceOfOrderFragileLabel.centerYAnchor.constraint(equalTo: priceImageView.centerYAnchor).isActive = true
        priceOfOrderFragileLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
    }
    
    func setupNoteLabel(){
        layoutImageView(topAnchor: priceOfOrderFragileLabel, imageName: "edit", to: noteImageView)
        self.addSubview(noteLabel)
        noteLabel.anchorWithConstants(top: nil, left: noteImageView.rightAnchor, bottom: nil, right: self.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 8)
        noteLabel.centerYAnchor.constraint(equalTo: noteImageView.centerYAnchor).isActive = true
        noteLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
    }
    
    private static func buttonForTitle(title:String, imageName:String) -> UIButton{
        let button = UIButton()
        button.setTitle(" \(title)", for: .normal)
        button.setImage(UIImage(named: imageName)?.resizeImage(newSize: CGSize(width: 22, height: 22)), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(#colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1), for: .normal)
        button.setTitleColor(UIColor.red, for: .highlighted)
        return button
    }
    
    // MARK: Views
    let statusOrderLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.red
        return label
    }()
    
    let stopTime:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.text = "9h truosc "
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let separatorView:UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.5807225108, green: 0.066734083, blue: 0, alpha: 1)
        return view
    }()
    
    let originAddressLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = "Hồ hoàn kiếm, hồ gươm, hà nội, trương định trần đại nghĩa"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    
    let destinationLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "Hồ hoàn kiếm, hồ gươm, hà nội, trương định trần đại nghĩa"
        return label
    }()
    
    let phoneOrdererLabel:UILabel = UILabel()
    let phoneReceiverLabel:UILabel = UILabel()
    let weightLabel: UILabel = UILabel()
    let prepaymentLabel: UILabel  = UILabel()
    let feeShipLabel: UILabel = UILabel()
    let priceOfOrderFragileLabel: UILabel = UILabel()
    let noteLabel:UILabel = UILabel()
    
    let originImageView = UIImageView()
    let destinationImageView = UIImageView()
    let weightImageView = UIImageView()
    let prepaymentImageView = UIImageView()
    let feeShipImageView = UIImageView()
    let priceImageView = UIImageView()
    let noteImageView = UIImageView()
    let phoneReceiverImageView = UIImageView()
    let phoneOrdererImageView = UIImageView()
    
}
