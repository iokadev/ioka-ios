//
//  OrderStatusView.swift
//  iOKA
//
//  Created by ablai erzhanov on 02.03.2022.
//

import Foundation
import UIKit

internal protocol PaymentResultViewDelegate: NSObject {
    func retry()
    func close()
}

internal class PaymentResultView: UIView {
    
    private let imageView = IokaImageView()
    private let orderTitleLabel = IokaLabel(iokaFont: typography.heading)
    let orderNumberLabel = IokaLabel(iokaFont: typography.subtitle, iokaTextColor: colors.grey)
    let orderPriceLabel = IokaLabel(iokaFont: typography.heading2, iokaTextColor: colors.text)
    let errorDescriptionLabel = IokaLabel(iokaFont: typography.subtitle, iokaTextColor: colors.grey)
    private let retryOrCloseButton = IokaButton(iokaButtonState: .enabled)
    
    weak var delegate: PaymentResultViewDelegate?
    
    let order: Order
    let result: PaymentResult
    
    init(order: Order, result: PaymentResult) {
        self.order = order
        self.result = result
        super.init(frame: .zero)
        
        setupUI()
        setupActions()
        configure()
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    private func setupUI() {
        self.backgroundColor = colors.background
        [imageView, orderTitleLabel, orderNumberLabel, orderPriceLabel, errorDescriptionLabel, retryOrCloseButton].forEach{ self.addSubview($0) }
        
        
        imageView.centerX(in: self, top: self.safeAreaTopAnchor, paddingTop: 100, width: 120, height: 120)
        
        orderTitleLabel.centerX(in: self, top: imageView.bottomAnchor, paddingTop: 24)
        
        orderNumberLabel.centerX(in: self, top: orderTitleLabel.bottomAnchor, paddingTop: 40)
        
        orderPriceLabel.centerX(in: self, top: orderNumberLabel.bottomAnchor, paddingTop: 4)
        
        errorDescriptionLabel.anchor(top: orderTitleLabel.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        
        retryOrCloseButton.anchor(left: self.leftAnchor, bottom: self.safeAreaBottomAnchor, right: self.rightAnchor, paddingLeft: 16, paddingBottom: 16, paddingRight: 16, height: 56)
    }
    
    private func setupActions() {
        self.retryOrCloseButton.addTarget(self, action: #selector(handleRetryOrCloseButton), for: .touchUpInside)
    }
    
    @objc private func handleRetryOrCloseButton() {
        switch result {
        case .success:
            delegate?.close()
        case .error:
            delegate?.retry()
        }
    }
    
    @objc private func handleCloseButton() {
        delegate?.close()
    }
    
    private func configure() {
        [orderTitleLabel, orderPriceLabel, orderNumberLabel, errorDescriptionLabel].forEach{ $0.textAlignment = .center }
        
        switch result {
        case .success:
            orderTitleLabel.text = IokaLocalizable.orderPaid
            orderTitleLabel.textColor = colors.success
            orderPriceLabel.text = "\(order.price) ₸"

            if let text = orderNumberText() {
                orderNumberLabel.text = text
            } else {
                orderNumberLabel.isHidden = true
            }
            
            errorDescriptionLabel.isHidden = true
            retryOrCloseButton.setTitle(IokaLocalizable.ok, for: .normal)
            imageView.image = IokaImages.checkCircle
        case .error(let error):
            orderTitleLabel.text = IokaLocalizable.paymentFailed
            orderTitleLabel.textColor = colors.text
            orderPriceLabel.isHidden = true
            orderNumberLabel.isHidden = true
            retryOrCloseButton.setTitle(IokaLocalizable.retry, for: .normal)
            imageView.image = IokaImages.xCircle
            errorDescriptionLabel.numberOfLines = 0
            errorDescriptionLabel.text = error.localizedDescription
        }
    }
    
    private func orderNumberText() -> String? {
        guard let orderNumber = order.externalId else {
            return nil
        }
        
        let locale = IokaLocalizable.orderNumber
        
        return String(format: locale, orderNumber)
    }
}
