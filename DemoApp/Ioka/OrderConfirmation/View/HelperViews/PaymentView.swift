//
//  PaymentView.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import UIKit

internal protocol PaymentViewDelegate: NSObject {
    func handleViewTap(_ view: PaymentView)
}


internal class PaymentView: UIView {
    
    public var paymentState: PaymentTypeState = .empty {
        didSet {
            configureView(paymentState: paymentState)
        }
    }
    
    public weak var delegate: PaymentViewDelegate?
    private let paymentTypeLabel = DemoLabel(title: "Выберите способ оплаты", font: typography.body, textColor: colors.nonadaptableGrey)
    private let paymentTypeImageView = DemoImageView(imageName: "paymentType")
    private let chevronRightImageView = DemoImageView(imageName: "chevronRight")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setActions()
    }
    
    convenience init(delegate: PaymentViewDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setActions() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleViewTap)))
    }
    
    @objc private func handleViewTap() {
        delegate?.handleViewTap(self)
    }
    
    private func configureView(paymentState: PaymentTypeState) {
        
        switch paymentState {
        case .empty:
            paymentTypeLabel.text = "Выберите способ оплаты"
            paymentTypeLabel.textColor = colors.nonadaptableGrey
        case .savedCard(let card):
            paymentTypeLabel.text = card.maskedPAN.trimPanMasked()
            paymentTypeLabel.textColor = colors.text
            paymentTypeImageView.image = card.paymentSystemIcon
        case .creditCard(let title):
            paymentTypeLabel.text = title
            paymentTypeLabel.textColor = colors.text
        case .applePay(let title):
            paymentTypeLabel.text = title
            paymentTypeLabel.textColor = colors.text
        case .cash(let title):
            paymentTypeLabel.text = title
            paymentTypeLabel.textColor = colors.text
        }
    }
  
    private func setupUI() {
        self.backgroundColor = colors.quaternaryBackground
        self.layer.cornerRadius = 8
        
        [paymentTypeLabel, paymentTypeImageView, chevronRightImageView].forEach{ self.addSubview($0) }
        
        paymentTypeImageView.anchor(left: self.leftAnchor, bottom: self.bottomAnchor, paddingLeft: 16, paddingBottom: 16, width: 24, height: 24)
        
        paymentTypeLabel.centerY(in: paymentTypeImageView, left: paymentTypeImageView.rightAnchor, paddingLeft: 12)
        
        chevronRightImageView.centerY(in: paymentTypeImageView, right: self.rightAnchor, paddingRight: 16, width: 20, height: 20)
    }
}
