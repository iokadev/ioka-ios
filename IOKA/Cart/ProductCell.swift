//
//  OrderCell.swift
//  iOKA
//
//  Created by ablai erzhanov on 09.03.2022.
//

import Foundation
import UIKit



class ProductCell: UITableViewCell {
    
    let backView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    static let cellId = "ProductCell"
    
    let productNumber = IokaLabel(iokaFont: Typography.subtitleSmall, iokaTextColor: UIColor(red: 0.582, green: 0.582, blue: 0.65, alpha: 1))
    let productTitle = IokaLabel(iokaFont: Typography.body, iokaTextColor: UIColor(red: 26/163, green: 26/163, blue: 43/255, alpha: 1))
    let productImageView = IokaImageView(imageName: "productImage", cornerRadius: 8)
    let productPriceLabel = IokaLabel(iokaFont: Typography.bodySemibold, iokaTextColor: UIColor(red: 26/163, green: 26/163, blue: 43/255, alpha: 1))
    let deleteImageView = IokaImageView(imageName: "deleteProduct", imageTintColor: nil)
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.941, green: 0.941, blue: 0.961, alpha: 1)
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(model: OrderModel) {
        self.productTitle.text = model.orderTitle
        self.productNumber.text = model.orderNumber
        self.productPriceLabel.text = model.orderPrice
    }
    
    private func setUI() {
        self.contentView.addSubview(backView)
        
        [productNumber, productTitle, productImageView, productPriceLabel, deleteImageView, seperatorView].forEach { backView.addSubview($0) }
        
        productNumber.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(12)
        }
        
        productTitle.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(productNumber.snp.bottom).offset(4)
        }
        
        productImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(12)
            make.width.height.equalTo(88)
        }
        
        seperatorView.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(productImageView.snp.bottom).offset(12)
        }
        
        productPriceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalTo(seperatorView.snp.bottom).offset(12)
            make.bottom.equalToSuperview().inset(12)
        }
        
        deleteImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.top.equalTo(seperatorView.snp.bottom).offset(12)
            make.width.height.equalTo(20)
        }
        
        backView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview()
            make.bottom.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(16)
        }
    }
}
