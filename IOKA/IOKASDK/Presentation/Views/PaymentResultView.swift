//
//  OrderStatusView.swift
//  iOKA
//
//  Created by ablai erzhanov on 02.03.2022.
//

import Foundation
import UIKit

protocol PaymentResultViewDelegate: NSObject {
    func tryAgain()
    func closePaymentResult()
}

class PaymentResultView: UIView {
    
    private let closeButton = IokaButton(imageName: "Close")
    private let imageView = IokaImageView()
    private let orderTitleLabel = IokaLabel(iokaFont: Typography.heading)
    let orderNumberLabel = IokaLabel(iokaFont: Typography.subtitle, iokaTextColor: IOKA.shared.theme.grey)
    let orderPriceLabel = IokaLabel(iokaFont: Typography.heading2, iokaTextColor: IOKA.shared.theme.text)
    let errorDescriptionLabel = IokaLabel(iokaFont: Typography.subtitle, iokaTextColor: IOKA.shared.theme.grey)
    private let retryOrCloseButton = IokaButton(iokaButtonState: .enabled)
    
    weak var delegate: PaymentResultViewDelegate?
    
    var paymentResult: PaymentResult? {
        didSet {
            setupOrderViewStatus()
        }
    }
    
    var paymentResponse: CardPaymentResponse? {
        didSet {
            setPaymentData()
        }
    }
    
    var error: IokaError? {
        didSet {
            setPaymentData()
        }
    }
    
    var orderResponse: GetOrderResponse? {
        didSet {
            setOrderData(order: orderResponse)
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
    
    private func setupActions() {
        self.retryOrCloseButton.addTarget(self, action: #selector(handleRetryOrCloseButton), for: .touchUpInside)
        self.closeButton.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
    }
    
    @objc private func handleRetryOrCloseButton() {
        guard let paymentResult = paymentResult else { return }

        switch paymentResult {
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
        
        guard let orderStatusState = paymentResult else { return }
        switch orderStatusState {
        case .paymentSucceed:
            orderTitleLabel.text = IokaLocalizable.orderPaid
            orderTitleLabel.textColor = IOKA.shared.theme.success
            errorDescriptionLabel.isHidden = true
            retryOrCloseButton.setTitle(IokaLocalizable.ok, for: .normal)
            imageView.image = IokaImages.checkCircle
        case .paymentFailed:
            orderTitleLabel.text = IokaLocalizable.paymentFailed
            orderTitleLabel.textColor = IOKA.shared.theme.text
            orderPriceLabel.isHidden = true
            orderNumberLabel.isHidden = true
            retryOrCloseButton.setTitle(IokaLocalizable.retry, for: .normal)
            imageView.image = IokaImages.xCircle
            errorDescriptionLabel.numberOfLines = 0
        }
    }
    
    private func setPaymentData() {
        if let orderResponse = paymentResponse {
            errorDescriptionLabel.text = orderResponse.error?.message
        }
        
        if let error = error {
            errorDescriptionLabel.text = error.message
        }
    }
    
    private func setOrderData(order: GetOrderResponse?) {
        guard let order = order else { return }

        orderPriceLabel.text = String(order.amount)
        orderNumberLabel.text = order.id
    }
}
