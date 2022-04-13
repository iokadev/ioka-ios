//
//  OrderInformationView.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import UIKit


internal protocol OrderInformationViewDelegate: NSObject {
    func handleViewTap(_ view: PayWithCashView, isPayWithCashSelected: Bool)
}


internal class OrderInformationView: UIView {
    
    private let orderAdressLabel = DemoLabel(font: typography.body, textColor: colors.text)
    private let orderTimeLabel = DemoLabel(font: typography.body, textColor: colors.text)
    private let orderAdressImageView = DemoImageView(imageName: "orderAdress")
    private let orderTimeImageView = DemoImageView(imageName: "orderTime")
    private let seperatorView = DemoCustomView(backGroundColor: colors.fill4)
    private let chevronRightImageViewAdress = DemoImageView(imageName: "chevronRight")
    private let chevronRightImageViewTime = DemoImageView(imageName: "chevronRight")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    func setUpView(order: OrderModel?) {
        guard let order = order else { return }
        orderAdressLabel.text = order.orderAdress
        orderTimeLabel.text = order.orderTime
    }
    
    private func setupUI() {
        self.backgroundColor = colors.tertiaryBackground
        self.layer.cornerRadius = 8
        [orderAdressLabel, orderTimeLabel, orderAdressImageView, orderTimeImageView, seperatorView, chevronRightImageViewAdress, chevronRightImageViewTime].forEach{ self.addSubview($0) }
        
        orderAdressImageView.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 16, paddingLeft: 16, width: 24, height: 24)
        
        orderAdressLabel.centerY(in: orderAdressImageView, left: orderAdressImageView.rightAnchor, paddingLeft: 12)
        
        chevronRightImageViewAdress.centerY(in: orderAdressImageView, right: self.rightAnchor, paddingRight: 16, width: 20, height: 20)
        
        orderTimeImageView.anchor(left: self.leftAnchor, bottom: self.bottomAnchor, paddingLeft: 16, paddingBottom: 16, width: 24, height: 24)
        
        orderTimeLabel.centerY(in: orderTimeImageView, left: orderTimeImageView.rightAnchor, paddingLeft: 12)
        
        chevronRightImageViewTime.centerY(in: orderTimeImageView, right: self.rightAnchor, paddingRight: 16, width: 20, height: 20)
        
        seperatorView.centerY(in: self, left: self.leftAnchor, paddingLeft: 52, right: self.rightAnchor, paddingRight: 0, height: 1)
    }
}
