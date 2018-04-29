//
//  OdererEnterInfoController.swift
//  WheelShip
//
//  Created by Nguyen Nam on 3/12/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

extension OrdererEnterInfoController {

    func setupPageControl(){
        view.addSubview(pageControl)
        pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
    }
    
    func setupPhoneReciverTextField(){
        view.addSubview(phoneReceiverTextField)
        phoneReceiverTextField.anchorWithConstants(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor,topConstant: 24)
        phoneReceiverTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupFragileObjectView(){
        view.addSubview(fragileObjectView)
        fragileObjectView.anchorWithConstants(top: phoneReceiverTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor)
        fragileObjectView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        // make sub views
        setupSubViewWithImageAndLabel(to: fragileObjectView, image: #imageLiteral(resourceName: "fragile"), label: priceFragileLabel)
        fragileObjectView.addSubview(isFragileSwitch)
        isFragileSwitch.centerYAnchor.constraint(equalTo: fragileObjectView.centerYAnchor).isActive = true
        isFragileSwitch.rightAnchor.constraint(equalTo: fragileObjectView.rightAnchor, constant: -8).isActive = true
    }
    
    func setupWeightContainerView(){
        view.addSubview(weightContainerView)
        weightContainerView.anchorWithConstants(top: fragileObjectView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor)
        weightContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        // sub views
        setupSubViewWithImageAndLabel(to: weightContainerView, image: #imageLiteral(resourceName: "weight"), label:weightLabel)
        setupRightImage(to: weightContainerView, image:#imageLiteral(resourceName: "down-arrow"))
        setupWeightPickerView()
    }
    
    func setupWeightPickerView(){
        view.addSubview(weightPickerView)
        weightPickerView.anchorWithConstants(top: weightContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor)
        heightConstaintOfWeightPickerView = NSLayoutConstraint(item: weightPickerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
        view.addConstraint(heightConstaintOfWeightPickerView!)
    }
    
    func setupPrepaymentTextField(){
        view.addSubview(prepaymentTextField)
        prepaymentTextField.anchorWithWidthHeightConstant(top: weightPickerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor)
        prepaymentTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupNoteTextField(){
        view.addSubview(noteTextField)
        noteTextField.anchorWithConstants(top: prepaymentTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        noteTextField.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    func setupOverheadsStackView(){
        view.addSubview(overheadsStackView)
        overheadsStackView.anchorWithWidthHeightConstant(top: nil, left: view.leftAnchor, bottom: pageControl.topAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 8, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        // add sub views to stack view
        let dummyTitleLabel:UILabel = UILabel()
        dummyTitleLabel.textColor = UIColor.white
        dummyTitleLabel.textAlignment = .center
        dummyTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        dummyTitleLabel.text = "Tổng phí"
        overheadsStackView.addArrangedSubview(dummyTitleLabel)
        overheadsStackView.addArrangedSubview(overheadsLabel)
    }
    
    func setupDividerView(){
        view.addSubview(dividerView)
        dividerView.anchorWithWidthHeightConstant(top: nil, left: view.leftAnchor, bottom: overheadsStackView.topAnchor, right: view.rightAnchor,topConstant: 0,leftConstant: 12, bottomConstant: 0,rightConstant: 12,widthConstant: 0,heightConstant: 0.5)
    }
    
    func setupDistanceLabel(){
        view.addSubview(distanceLabel)
        distanceLabel.anchorWithWidthHeightConstant(top: noteTextField.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor,topConstant:0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
    }
   
    
    func setupSubViewWithImageAndLabel(to view:UIView, image:UIImage, label:UILabel){
        // make subs view
        let image = UIImageView(image: image)
        view.addSubview(image)
        image.frame = CGRect(x: 8, y: 12.5, width: 25, height: 25)
        view.addSubview(label)
        label.textAlignment = .justified
        // x,y,w,h
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: image.rightAnchor, constant: 8).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 16).isActive = true
    }
    
    func setupRightImage(to view:UIView, image:UIImage){
        let subView = UIView()
        view.addSubview(subView)
        subView.anchorWithConstants(top: view.topAnchor, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor,topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 8)
        subView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        let image = UIImageView(image: image)
        subView.addSubview(image)
        image.frame = CGRect(x: 0, y: 16, width: 18, height: 18)
    }
    
}
