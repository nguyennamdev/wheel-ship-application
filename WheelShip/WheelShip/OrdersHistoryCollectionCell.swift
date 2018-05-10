//
//  OrdersHistoryCollectionCEll.swift
//  WheelShip
//
//  Created by Nguyen Nam on 4/21/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class OrdersHistoryCollectionCell : BaseCell {
    
    // MARK: Properties
    var isShowingActions:Bool = false
    var orderHistoryDelegate:OrdersHistoryDelegate?
    var oder:Order?{
        didSet{
            showingDetailContainer()
            guard let order = self.oder else { return }
            setBasicValue(order: order)
            setDetailValue(order: order)
            if order.status == OrderStage.hadShipper {
                self.stateImageView.image = #imageLiteral(resourceName: "check")
            }else{
                self.stateImageView.image = #imageLiteral(resourceName: "sand-clock")
            }
            if order.shipperId == ""{
                infoShipperLabel.attributedText = attitudeString((Define.SHIPPER, #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), (" Chưa có người nhận", UIColor.white))
            }else{
            }
        }
    }
    
    var rightConstraintContainerView:NSLayoutConstraint?
    var leftConstaintContainnerView:NSLayoutConstraint?
    
    // closure attitudeString
    let attitudeString = { (title:(String,UIColor),content:(String, UIColor)) -> NSMutableAttributedString in
        let attritude = NSMutableAttributedString(string: title.0, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: title.1])
        attritude.append(NSAttributedString(string: content.0, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: content.1]))
        return attritude
    }
    
    
    override func setupViews() {
        setContainView()
        setupDateLabel()
        setupInfoShipperLabel()
        setupStateImage()
        setupOriginAddressLabel()
        setupDestinationAddressLabel()
        setupPhoneReceiverLabel()
        setupDownArrowView()
        setupDetailContainer()
        setupActionView()
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(leftSwipeGesture)
        self.addGestureRecognizer(righSwipeGesture)
    }
    
    // MARK: Private functions
    private func showingDetailContainer(){
        if (self.oder?.isShowing)!{
            downArrowView.image = #imageLiteral(resourceName: "up-arrow")
            detailContainer.isHidden = false
        }else{
            downArrowView.image = #imageLiteral(resourceName: "drop-down-arrow")
            detailContainer.isHidden = true
        }
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }
    private func setBasicValue(order:Order){
        guard let date = order.startTime,
            let shipperId = order.shipperId,
            let originAddress = order.originAddress,
            let destinationAddress = order.destinationAddress,
            let phoneReceiver = order.phoneReceiver
            else { return }
        dateLabel.text = date
        infoShipperLabel.attributedText = attitudeString((Define.SHIPPER,#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), (" \(shipperId)", UIColor.white))
        originLabel.attributedText = attitudeString((Define.ORIGIN_ADDRESS,#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), (" \(originAddress)", UIColor.white))
        destinationLabel.attributedText = attitudeString((Define.DESTINATION_ADDRESS,#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), (" \(destinationAddress)", UIColor.white))
        phoneReceiverLabel.attributedText = attitudeString((Define.PHONE_RECEIVER,#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), (" \(phoneReceiver)", UIColor.white))
    }
    
    
    private func setDetailValue(order:Order){
        guard let prepayment = order.unitPrice?.prepayment,
            let priceOfWeight = order.unitPrice?.priceOfWeight,
            let priceOrderFragile = order.unitPrice?.priceFragileOrder,
            let feeShip = order.unitPrice?.feeShip,
            let overheads = order.unitPrice?.overheads else { return }
        if order.isFragile{
            detailContainer.addArrangedSubview(priceOfOrderFragileLabel)
        }
        detailContainer.addArrangedSubview(feeShipLabel)
        detailContainer.addArrangedSubview(overheadsLabel)
        prepaymentLabel.attributedText = attitudeString((Define.PREPAYMENT, #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), (" \(prepayment.formatedNumberWithUnderDots())", UIColor.white))
        priceOfWeightLabel.attributedText = attitudeString((Define.PRICE_OF_WEIHGT, #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), (" \(priceOfWeight.formatedNumberWithUnderDots())", UIColor.white))
        if order.isFragile{
            priceOfOrderFragileLabel.attributedText = attitudeString((Define.PRICE_OF_ORDER_FRAGILE, #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), (" \(priceOrderFragile.formatedNumberWithUnderDots())", UIColor.white))
        }
        feeShipLabel.attributedText = attitudeString((Define.FEESHIP, #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), (" \(feeShip.formatedNumberWithUnderDots())", UIColor.white))
        overheadsLabel.attributedText = attitudeString((Define.OVERHEADS, #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), (" \(overheads.formatedNumberWithUnderDots())", UIColor.white))
    }
    
    // MARK: Actions
    
    @objc private func showActions(){
        if !isShowingActions {
            // margin 8 value
            self.rightConstraintContainerView?.constant = -58
            self.leftConstaintContainnerView?.constant = -58
            self.actionView.isHidden = false
        }
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        isShowingActions = !isShowingActions
    }
    
    @objc private func hideActions(){
        if isShowingActions {
            self.rightConstraintContainerView?.constant = -12
            self.leftConstaintContainnerView?.constant = 12
            self.actionView.isHidden = true
        }
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
        isShowingActions = !isShowingActions
    }
    
    @objc private func deleteAOrder(){
        if let orderId = self.oder?.orderId {
             orderHistoryDelegate?.deleteAOrderByOrderId(orderId: orderId)
        }
    }
    
    @objc private func editAOrder(){
        if let orderId = self.oder?.orderId {
            orderHistoryDelegate?.editAOrderByOrderId(orderId: orderId)
        }
    }

    // MARK:setup view
    private func setContainView(){
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        // left, right constaint
        leftConstaintContainnerView = NSLayoutConstraint(item: containerView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 12)
        rightConstraintContainerView = NSLayoutConstraint(item: containerView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: -12)
        self.addConstraint(leftConstaintContainnerView!)
        self.addConstraint(rightConstraintContainerView!)
        containerView.addSubview(gradient)
        gradient.anchorWithConstants(top: self.containerView.topAnchor, left: self.containerView.leftAnchor, bottom: self.containerView.bottomAnchor, right: self.containerView.rightAnchor)
    }
    
    private func setupDateLabel(){
        containerView.addSubview(dateLabel)
        dateLabel.anchorWithConstants(top: containerView.topAnchor, left: nil, bottom: nil, right: containerView.rightAnchor, topConstant: 4, leftConstant: 0, bottomConstant: 0, rightConstant: 8)
    }
    
    private func setupInfoShipperLabel(){
        containerView.addSubview(infoShipperLabel)
        infoShipperLabel.anchorWithConstants(top: dateLabel.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 4, leftConstant: 8, bottomConstant: 0, rightConstant: 4)
    }
    
    private func setupOriginAddressLabel(){
        containerView.addSubview(originLabel)
        originLabel.anchorWithConstants(top: infoShipperLabel.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: stateImageView.leftAnchor, topConstant: 4, leftConstant: 8, bottomConstant: 0, rightConstant: 4)
        originLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
    
    private func setupDestinationAddressLabel(){
        containerView.addSubview(destinationLabel)
        destinationLabel.anchorWithConstants(top: originLabel.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: stateImageView.leftAnchor, topConstant: 4, leftConstant: 8, bottomConstant: 0, rightConstant: 4)
        destinationLabel.heightAnchor.constraint(equalToConstant: 32).isActive = true
    }
    
    private func setupPhoneReceiverLabel(){
        containerView.addSubview(phoneReceiverLabel)
        phoneReceiverLabel.anchorWithConstants(top: destinationLabel.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 4, leftConstant: 8, bottomConstant: 0, rightConstant: 4)
    }
    
    private func  setupStateImage(){
        containerView.addSubview(stateImageView)
        stateImageView.translatesAutoresizingMaskIntoConstraints = false
        stateImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        stateImageView.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -12).isActive = true
        stateImageView.widthAnchor.constraint(equalToConstant: 32).isActive = true
        stateImageView.heightAnchor.constraint(equalToConstant: 32).isActive = true
        stateImageView.image = #imageLiteral(resourceName: "sand-clock")
    }
    
    private func setupDownArrowView(){
        containerView.addSubview(downArrowView)
        downArrowView.translatesAutoresizingMaskIntoConstraints = false
        downArrowView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        downArrowView.topAnchor.constraint(equalTo: phoneReceiverLabel.bottomAnchor).isActive = true
        downArrowView.widthAnchor.constraint(equalToConstant: 16).isActive = true
        downArrowView.heightAnchor.constraint(equalToConstant: 16).isActive = true
    }
    
    private func setupDetailContainer(){
        containerView.addSubview(detailContainer)
        detailContainer.translatesAutoresizingMaskIntoConstraints = false
        detailContainer.topAnchor.constraint(equalTo: downArrowView.bottomAnchor).isActive = true
        detailContainer.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        detailContainer.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -4).isActive = true
        detailContainer.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -4).isActive = true
        // add subview
        detailContainer.addArrangedSubview(prepaymentLabel)
        detailContainer.addArrangedSubview(priceOfWeightLabel)
    }
    
    private func setupActionView(){
        self.addSubview(actionView)
        actionView.anchorWithWidthHeightConstant(top: self.topAnchor, left: containerView.rightAnchor, bottom: self.bottomAnchor, right: nil, topConstant: 0, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 50)
        // set up subviews
        actionView.addSubview(editActionButton)
        actionView.addSubview(deleteActionButton)
        editActionButton.anchorWithConstants(top: actionView.topAnchor, left: actionView.leftAnchor, bottom: nil, right: actionView.rightAnchor)
        editActionButton.heightAnchor.constraint(equalTo: actionView.heightAnchor, multiplier: 0.5).isActive = true
        
        deleteActionButton.anchorWithConstants(top: editActionButton.bottomAnchor, left: actionView.leftAnchor, bottom: actionView.bottomAnchor, right: actionView.rightAnchor)
    }
    
    // MARK: Views
    let containerView:UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.isUserInteractionEnabled = true
        return view
    }()
    
    let gradient:GradientView = {
        let layer = GradientView()
        layer.colors = [
            UIColor.rgb(r: 20, g: 30, b: 48).cgColor,
            UIColor.rgb(r: 36, g: 59, b: 85).cgColor
        ]
        return layer
    }()
    
    let dateLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let originLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let destinationLabel:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    let infoShipperLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.numberOfLines = 0
        return label
    }()
    
    let phoneReceiverLabel:UILabel = {
        let label = UILabel()
        return label
    }()
    
    let stateImageView:UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    let downArrowView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "drop-down-arrow")
        return imageView
    }()
    
    let detailContainer:UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    let prepaymentLabel:UILabel = {
        let label = UILabel()
        return label
    }()
    
    let priceOfWeightLabel:UILabel = {
        let label = UILabel()
        return label
    }()
    
    let priceOfOrderFragileLabel:UILabel = {
        let label = UILabel()
        return label
    }()
    
    let feeShipLabel:UILabel = {
        let label = UILabel()
        return label
    }()
    
    let overheadsLabel:UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var leftSwipeGesture:UISwipeGestureRecognizer = {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(showActions))
        swipeGesture.direction = .left
        return swipeGesture
    }()
    
    lazy var righSwipeGesture:UISwipeGestureRecognizer  = {
        let swipteGesture = UISwipeGestureRecognizer(target: self, action: #selector(hideActions))
        swipteGesture.direction = .right
        return swipteGesture
    }()
    
    let actionView:UIView = {
        let view = UIView()
        //34,193,195
        view.backgroundColor = UIColor.rgb(r: 34, g: 193, b: 195)
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        view.isHidden = true
        return view
    }()
    
    lazy var editActionButton:UIButton = {
        let button = UIButton()
        //86,204,242
        button.backgroundColor = UIColor.rgb(r: 86, g: 204, b: 242)
        button.setImage(#imageLiteral(resourceName: "edit"), for: .normal)
        button.addTarget(self, action: #selector(editAOrder), for: .touchUpInside)
        return button
    }()
    
    lazy var deleteActionButton:UIButton = {
        let button = UIButton()
        //240,80,83
        button.backgroundColor = UIColor.rgb(r: 240, g: 80, b: 83)
        button.setImage(#imageLiteral(resourceName: "delete"), for: .normal)
        button.addTarget(self, action: #selector(deleteAOrder), for: .touchUpInside)
        return button
    }()
    
}
