//
//  OrderStatusView.swift
//  iOKA
//
//  Created by ablai erzhanov on 02.03.2022.
//

import Foundation
import UIKit

internal protocol PaymentResultViewDelegate: NSObject {
    func tryAgain()
    func closePaymentResult()
}

internal class PaymentResultView: UIView {
    
    private let closeButton = IokaButton(imageName: "Close")
    private let imageView = IokaImageView()
    private let orderTitleLabel = IokaLabel(iokaFont: typography.heading)
    let orderNumberLabel = IokaLabel(iokaFont: typography.subtitle, iokaTextColor: colors.grey)
    let orderPriceLabel = IokaLabel(iokaFont: typography.heading2, iokaTextColor: colors.text)
    let errorDescriptionLabel = IokaLabel(iokaFont: typography.subtitle, iokaTextColor: colors.grey)
    private let retryOrCloseButton = IokaButton(iokaButtonState: .enabled)
    
    weak var delegate: PaymentResultViewDelegate?
    
    var paymentResult: PaymentResult? {
        didSet {
            setupOrderViewStatus()
        }
    }
    
    var error: Error? {
        didSet {
            setPaymentData()
        }
    }
    
    var order: Order? {
        didSet {
            setOrderData(order: order)
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
    
    func configureView(error: Error? = nil, order: Order? = nil, paymentResult: PaymentResult) {
        self.error = error
        self.order = order
        self.paymentResult = paymentResult
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
        
        orderTitleLabel.centerX(in: self, top: imageView.bottomAnchor, paddingTop: 24)
        
        orderNumberLabel.centerX(in: self, top: orderTitleLabel.bottomAnchor, paddingTop: 40)
        
        orderPriceLabel.centerX(in: self, top: orderNumberLabel.bottomAnchor, paddingTop: 4)
        
        errorDescriptionLabel.anchor(top: orderTitleLabel.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        retryOrCloseButton.anchor(left: self.leftAnchor, bottom: self.safeAreaBottomAnchor, right: self.rightAnchor, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, height: 56)
    }
    
    private func setupOrderViewStatus() {
        [orderTitleLabel, orderPriceLabel, orderNumberLabel, errorDescriptionLabel].forEach{ $0.textAlignment = .center }
        
        guard let orderStatusState = paymentResult else { return }
        switch orderStatusState {
        case .paymentSucceed:
            orderTitleLabel.text = IokaLocalizable.orderPaid
            orderTitleLabel.textColor = colors.success
            errorDescriptionLabel.isHidden = true
            retryOrCloseButton.setTitle(IokaLocalizable.ok, for: .normal)
            imageView.image = IokaImages.checkCircle
        case .paymentFailed:
            orderTitleLabel.text = IokaLocalizable.paymentFailed
            orderTitleLabel.textColor = colors.text
            orderPriceLabel.isHidden = true
            orderNumberLabel.isHidden = true
            retryOrCloseButton.setTitle(IokaLocalizable.retry, for: .normal)
            imageView.image = IokaImages.xCircle
            errorDescriptionLabel.numberOfLines = 0
        }
    }
    
    private func setPaymentData() {
        if let error = error {
            errorDescriptionLabel.text = error.localizedDescription
        }
    }
    
    private func setOrderData(order: Order?) {
        guard let order = order else { return }
        
        orderPriceLabel.text = "\(order.price) ₸"
        let locale = IokaLocalizable.orderNumber
        if let orderNumber = order.externalId {
            orderNumberLabel.text = String(format: locale, orderNumber)
        } else {
            orderNumberLabel.isHidden = true
        }
        
    }
}
