//
//  OrdersHistoryCollectionCEll.swift
//  WheelShip
//
//  Created by Nguyen Nam on 4/21/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class OrdersHistoryCollectionCell : BaseCell {
    
    var isHadShipper:Bool = false
    var isFragile:Bool = true
    // closure attitudeString
    let attitudeString = { (title:(String,UIColor),content:(String, UIColor)) -> NSMutableAttributedString in
        let attritude = NSMutableAttributedString(string: title.0, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: title.1])
        attritude.append(NSAttributedString(string: content.0, attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 13), NSAttributedStringKey.foregroundColor: content.1]))
        return attritude
    }
    
    var a:AAA?{
        didSet{
            if (a?.isShowing)!{
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
        
      
        
    }
    
    // MARK:setup view
    private func setContainView(){
        addSubview(containerView)
        containerView.anchorWithConstants(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 12)
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
        infoShipperLabel.attributedText = attitudeString(("Shipper: ",#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), ("Nguyen Tu Vu", UIColor.white))
    }
    
    private func setupOriginAddressLabel(){
        containerView.addSubview(originLabel)
        originLabel.anchorWithConstants(top: infoShipperLabel.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: stateImageView.leftAnchor, topConstant: 4, leftConstant: 8, bottomConstant: 0, rightConstant: 4)
        originLabel.attributedText = attitudeString(("Điểm bắt đầu: ",#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), ("Tam trinh", UIColor.white))
    }
    
    private func setupDestinationAddressLabel(){
        containerView.addSubview(destinationLabel)
        destinationLabel.anchorWithConstants(top: originLabel.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: stateImageView.leftAnchor, topConstant: 4, leftConstant: 8, bottomConstant: 0, rightConstant: 4)
        destinationLabel.attributedText = attitudeString(("Điểm đến", #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), ("123 Tran Dai Nghia, Ha Noi", UIColor.white))
    }
    
    private func setupPhoneReceiverLabel(){
        containerView.addSubview(phoneReceiverLabel)
        phoneReceiverLabel.anchorWithConstants(top: destinationLabel.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, topConstant: 4, leftConstant: 8, bottomConstant: 0, rightConstant: 4)
        phoneReceiverLabel.attributedText = attitudeString(("SĐT người nhận", #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), ("0165786310", UIColor.white))
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
        if isFragile{
            detailContainer.addArrangedSubview(priceOfOrderFragileLabel)
        }
        detailContainer.addArrangedSubview(feeShipLabel)
        detailContainer.addArrangedSubview(overheadsLabel)
        
        prepaymentLabel.attributedText = attitudeString(("Tiền ứng: ", #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), ("0165786310", UIColor.white))
        priceOfWeightLabel.attributedText = attitudeString(("Phí khối lượng: ", #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), ("0165786310", UIColor.white))
        if isFragile{
            priceOfOrderFragileLabel.attributedText = attitudeString(("Phí hàng dễ vỡ: ", #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), ("0165786310", UIColor.white))
        }
        feeShipLabel.attributedText = attitudeString(("Phí vận chuyển: ", #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), ("0165786310", UIColor.white))
        overheadsLabel.attributedText = attitudeString(("Tổng phí: ", #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), ("0165786310", UIColor.white))
    }
    
    // MARK: Views
    let containerView:UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
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
        label.text = "22/2/2018 18:23 am"
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
        label.text = "22fafa"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let priceOfWeightLabel:UILabel = {
        let label = UILabel()
        label.text = "111111"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let priceOfOrderFragileLabel:UILabel = {
        let label = UILabel()
        label.text = "33333"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let feeShipLabel:UILabel = {
        let label = UILabel()
        label.text = "444444"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let overheadsLabel:UILabel = {
        let label = UILabel()
        label.text = "55555"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
}
