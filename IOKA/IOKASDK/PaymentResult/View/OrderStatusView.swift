//
//  OrderStatusView.swift
//  iOKA
//
//  Created by ablai erzhanov on 02.03.2022.
//

import Foundation
import UIKit

protocol OrderStatusViewDelegate: NSObject {
    func tryAgain()
    func closePaymentResult()
}

class OrderStatusView: UIView {
    
    private let closeButton = IokaButton(image: UIImage(named: "Close"))
    private let imageView = IokaImageView()
    private let orderTitleLabel = IokaLabel(iokaFont: Typography.heading)
    let orderNumberLabel = IokaLabel(iokaFont: Typography.subtitle, iokaTextColor: IokaColors.grey)
    let orderPriceLabel = IokaLabel(iokaFont: Typography.heading2, iokaTextColor: IokaColors.fill2)
    let errorDescriptionLabel = IokaLabel(iokaFont: Typography.subtitle, iokaTextColor: IokaColors.grey)
    private let retryOrCloseButton = IokaButton(iokaButtonState: .enabled)
    
    weak var delegate: OrderStatusViewDelegate?
    
    var orderStatusState: OrderStatus? {
        didSet {
            setupOrderViewStatus()
        }
    }
    
    var orderResponse: CardPaymentResponse? {
        didSet {
            setOrderViewData()
        }
    }
    
    var error: IokaError? {
        didSet {
            setOrderViewData()
        }
    }
  
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
    }
    
    private func setupActions() {
        self.retryOrCloseButton.addTarget(self, action: #selector(handleRetryOrCloseButton), for: .touchUpInside)
        self.closeButton.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
    }
    
    @objc private func handleRetryOrCloseButton() {
        guard let orderStatusState = orderStatusState else { return }

        switch orderStatusState {
        case .paymentFailed: delegate?.tryAgain()
        case .paymentSucceed: delegate?.closePaymentResult()
        }
    }
    
    @objc private func handleCloseButton() {
        delegate?.closePaymentResult()
    }
   
    private func setupUI() {
        self.backgroundColor = .white
        [closeButton, imageView, orderTitleLabel, orderNumberLabel, orderPriceLabel, errorDescriptionLabel, retryOrCloseButton].forEach{ self.addSubview($0) }
        
        closeButton.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 60, paddingLeft: 16, width: 24, height: 24)
        
        imageView.centerX(in: self, top: self.topAnchor, paddingTop: 180, width: 120, height: 120)
        
        orderTitleLabel.centerX(in: self, top: imageView.bottomAnchor, paddingTop: 36)
        
        orderNumberLabel.centerX(in: self, top: orderTitleLabel.bottomAnchor, paddingTop: 40)
        
        orderPriceLabel.centerX(in: self, top: orderNumberLabel.bottomAnchor, paddingTop: 4)
        
        errorDescriptionLabel.anchor(top: orderTitleLabel.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        retryOrCloseButton.anchor(left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingLeft: 16, paddingBottom: 50, paddingRight: 16, height: 56)
    }
    
    private func setupOrderViewStatus() {
        [orderTitleLabel, orderPriceLabel, orderNumberLabel, errorDescriptionLabel].forEach{ $0.textAlignment = .center }
        
        guard let orderStatusState = orderStatusState else { return }
        switch orderStatusState {
        case .paymentSucceed:
            orderTitleLabel.text = "Заказ оплачен"
            orderTitleLabel.textColor = IokaColors.success
            errorDescriptionLabel.isHidden = true
            retryOrCloseButton.setTitle("Понятно", for: .normal)
            imageView.image = UIImage(named: "CheckCircle")
        case .paymentFailed:
            orderTitleLabel.text = "Платеж не прошел"
            orderTitleLabel.textColor = IokaColors.fill2
            orderPriceLabel.isHidden = true
            orderNumberLabel.isHidden = true
            retryOrCloseButton.setTitle("Попробовать заново", for: .normal)
            imageView.image = UIImage(named: "XCircle")
            errorDescriptionLabel.numberOfLines = 0
        }
    }
    
    private func setOrderViewData() {
        if let orderResponse = orderResponse {
            errorDescriptionLabel.text = orderResponse.error?.message
            orderPriceLabel.text = String(orderResponse.captured_amount)
            orderNumberLabel.text = orderResponse.order_id
        }
        
        if let error = error {
            errorDescriptionLabel.text = error.message
        }
    }
}
