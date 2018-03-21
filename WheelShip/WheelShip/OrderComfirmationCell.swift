//
//  OrderComfirmationCell.swift
//  WheelShip
//
//  Created by Nguyen Nam on 3/20/18.
//  Copyright © 2018 Nguyen Nam. All rights reserved.
//

import UIKit

class OrderConfirmationCell: UICollectionViewCell {
    
    var confirmationItem:ConfirmationItem?{
        didSet{
            if let item = confirmationItem{
                self.imageView.image = item.image
                self.titleLabel.text = item.title
                self.contentLabel.text = item.content
            }
        }
    }

    override init(frame: CGRect) {
        super.init(frame:frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        setupImageView()
        setupTitleLabel()
        setupContentLabel()
        setupDividerView()
    }
    
    
    // MARK: Set up views
    private func setupImageView(){
        self.addSubview(imageView)
        imageView.anchorWithConstants(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: nil)
        imageView.widthAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    private func setupTitleLabel(){
        self.addSubview(titleLabel)
        titleLabel.anchorWithConstants(top: self.topAnchor, left: imageView.rightAnchor, bottom: nil, right: nil)
        titleLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/2).isActive = true
    }
    
    private func setupContentLabel(){
        self.addSubview(contentLabel)
        contentLabel.anchorWithConstants(top: titleLabel.bottomAnchor, left: imageView.rightAnchor, bottom: nil, right: nil)
        contentLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 1/2).isActive = true
    }
    
    private func setupDividerView(){
        self.addSubview(dividerView)
        dividerView.anchorWithConstants(top: nil, left: imageView.rightAnchor, bottom: self.bottomAnchor, right: self.rightAnchor,topConstant: 0,leftConstant: 0,bottomConstant: 0,rightConstant: 8)
        dividerView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    // MARK: Views
    let imageView:UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .center
        return imageView
    }()
    
    let titleLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let contentLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.gray
        return label
    }()
    
    let dividerView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.gray
        return view
    }()
}
