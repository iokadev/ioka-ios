//
//  OrderConfirmationView.swift
//  iOKA
//
//  Created by ablai erzhanov on 12.03.2022.
//

import Foundation
import UIKit
import SnapKit

protocol OrderConfirmationViewDelegate: NSObject {
    func confirmButtonWasPressed(_ orderView: UIView)
}

class OrderConfirmationView: UIView {
    
    var order: OrderModel? {
        didSet {
            configureView()
        }
    }
    
    weak var delegate: OrderConfirmationViewDelegate?
    
    private let orderTitleLabel = CustomLabel(customFont: Typography.subtitle, customTextColor: CustomColors.grey, customTextAlignemnt: .center)
    private let orderImageView = CustomImageView(imageName: "productImage", cornerRadius: 8)
    private let orderPriceLabel = CustomLabel(customFont: Typography.heading, customTextColor: CustomColors.fill2, customTextAlignemnt: .center)
    private let orderInformationView = CustomView(cornerRadius: 8)
    private let orderAdressLabel = CustomLabel(customFont: Typography.body, customTextColor: CustomColors.fill2)
    private let orderTimeLabel = CustomLabel(customFont: Typography.body, customTextColor: CustomColors.fill2)
    private let confirmButton = CustomButton(customButtonState: .enabled, title: "Оформить")
    private let orderAdressImageView = CustomImageView(imageName: "orderAdress")
    private let orderTimeImageView = CustomImageView(imageName: "orderTime")
    private let paymentView = CustomView(cornerRadius: 8)
    private let paymentTypeImageView = CustomImageView(imageName: "paymentType")
    private let seperatorView = CustomView(backGroundColor: CustomColors.fill4)
    let paymentTypeLabel = CustomLabel(title: "Выберите способ оплаты", customFont: Typography.body, customTextColor: CustomColors.grey)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupActions() {
        self.confirmButton.addTarget(self, action: #selector(handleConfirmButton), for: .touchUpInside)
    }
    
    @objc private func handleConfirmButton() {
        delegate?.confirmButtonWasPressed(self)
    }
    
    private func configureView() {
        guard let order = order else { return }
        
        orderTitleLabel.text = order.orderTitle
        orderPriceLabel.text = order.orderPrice
        orderAdressLabel.text = order.orderAdress
        orderTimeLabel.text = order.orderTime

    }
    
    private func setupUI() {

        self.backgroundColor = CustomColors.fill5
        [orderTitleLabel, orderImageView, orderPriceLabel, orderInformationView, paymentView, confirmButton].forEach{ self.addSubview($0) }
        
        orderTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(116)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        orderImageView.snp.makeConstraints { make in
            make.top.equalTo(orderTitleLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(120)
        }
        
        orderPriceLabel.snp.makeConstraints { make in
            make.top.equalTo(orderImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        orderInformationView.snp.makeConstraints { make in
            make.top.equalTo(orderPriceLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(113)
        }
        
        [orderAdressLabel, orderTimeLabel, orderAdressImageView, orderTimeImageView, seperatorView].forEach{ orderInformationView.addSubview($0) }
        
        orderAdressImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(16)
            make.width.height.equalTo(24)
        }
        
        orderAdressLabel.snp.makeConstraints { make in
            make.centerY.equalTo(orderAdressImageView.snp.centerY)
            make.leading.equalTo(orderAdressImageView.snp.trailing).offset(12)
        }
        
        orderTimeImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }
        
        orderTimeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(orderTimeImageView.snp.centerY)
            make.leading.equalTo(orderTimeImageView.snp.trailing).offset(12)
        }
        
        seperatorView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.equalTo(1)
            make.leading.equalToSuperview().inset(52)
            make.trailing.equalToSuperview()
        }
        
        paymentView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(orderInformationView.snp.bottom).offset(24)
            make.height.equalTo(56)
        }
        
        [paymentTypeLabel, paymentTypeImageView].forEach{ paymentView.addSubview($0) }
        
        paymentTypeImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
        }
        
        paymentTypeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(paymentTypeImageView.snp.centerY)
            make.leading.equalTo(paymentTypeImageView.snp.trailing).offset(12)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(56)
            make.bottom.equalToSuperview().inset(50)
        }
    }
}
