//
//  OrderCell.swift
//  iOKA
//
//  Created by ablai erzhanov on 09.03.2022.
//

import Foundation
import UIKit


internal class ProductCell: UITableViewCell {
    
    let backView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 8
        view.backgroundColor = colors.quaternaryBackground
        return view
    }()
    
    static let cellId = "ProductCell"
    
    let productNumber = DemoLabel(font: typography.subtitleSmall, textColor: colors.nonadaptableGrey)
    let productTitle = DemoLabel(font: typography.body, textColor: colors.text)
    let productImageView = DemoImageView(imageName: "productImage", cornerRadius: 8)
    let productPriceLabel = DemoLabel(font: typography.bodySemibold, textColor: colors.text)
    let deleteImageView = DemoImageView(imageName: "deleteProduct")
    let seperatorView = DemoCustomView(backGroundColor: colors.quaternaryBackground)
    
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
        [productNumber, productTitle, productImageView, seperatorView, productPriceLabel, deleteImageView].forEach { backView.addSubview($0) }
        
        productNumber.anchor(top: backView.topAnchor, left: backView.leftAnchor, paddingTop: 12, paddingLeft: 16)

        productTitle.anchor(top: productNumber.bottomAnchor, left: backView.leftAnchor, paddingTop: 4, paddingLeft: 16)

        productImageView.anchor(top: backView.topAnchor, right: backView.rightAnchor, paddingTop: 12, paddingRight: 16, width: 88, height: 88)

        seperatorView.anchor(top: productImageView.bottomAnchor, left: backView.leftAnchor, right: backView.rightAnchor, paddingTop: 12, paddingLeft: 16, paddingRight: 16, height: 1)

        productPriceLabel.anchor(top: seperatorView.bottomAnchor, left: backView.leftAnchor, bottom: backView.bottomAnchor, paddingTop: 12, paddingLeft: 16, paddingBottom: 12)

        deleteImageView.anchor(top: seperatorView.bottomAnchor, right: backView.rightAnchor, paddingTop: 12, paddingRight: 16, width: 20, height: 20)

        backView.anchor(top: self.contentView.topAnchor, left: self.contentView.leftAnchor, bottom: self.contentView.bottomAnchor, right: self.contentView.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingBottom: 0, paddingRight: 16)
    }
}
