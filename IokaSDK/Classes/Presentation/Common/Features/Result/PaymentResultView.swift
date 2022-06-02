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
    private lazy var stackView: UIStackView = {
        let arrangedSubviews: [UIView] = {
            if case .success = result {
                return [imageView,
                        orderTitleLabel,
                        orderNumberLabel,
                        orderPriceLabel]
            } else {
                return [imageView,
                        orderTitleLabel,
                        errorDescriptionLabel]
            }
        }()
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        
        return stackView
    }()
    
    private let imageView = IokaImageView()
    private let orderTitleLabel = IokaLabel(iokaFont: typography.heading, iokaTextAlignemnt: .center)
    private lazy var orderNumberLabel = IokaLabel(iokaFont: typography.subtitle, iokaTextColor: colors.nonadaptableGrey, iokaTextAlignemnt: .center)
    private lazy var orderPriceLabel = IokaLabel(iokaFont: typography.heading2, iokaTextColor: colors.text, iokaTextAlignemnt: .center)
    private lazy var errorDescriptionLabel = IokaLabel(iokaFont: typography.subtitle, iokaTextColor: colors.nonadaptableGrey, iokaTextAlignemnt: .center)
    private let retryOrCloseButton = IokaButton(state: .enabled)
    
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
        
        stackView.setCustomSpacing(24, after: imageView)
        
        if case .success = result {
            stackView.setCustomSpacing(40, after: orderTitleLabel)
        } else {
            stackView.setCustomSpacing(8, after: orderTitleLabel)
        }
        
        stackView.setCustomSpacing(4, after: orderNumberLabel)

        [stackView, retryOrCloseButton].forEach { self.addSubview($0) }
        
        stackView.anchor(top: safeAreaTopAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 100, paddingLeft: 24, paddingRight: 24)
        imageView.setDimensions(width: 120, height: 120)
        
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
            
            retryOrCloseButton.setTitle(IokaLocalizable.ok, for: .normal)
            imageView.image = IokaImages.checkCircle
        case .error(let error):
            orderTitleLabel.text = IokaLocalizable.paymentFailed
            orderTitleLabel.textColor = colors.text
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
