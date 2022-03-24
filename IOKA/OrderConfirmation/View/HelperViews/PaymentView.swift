//
//  PaymentView.swift
//  IOKA
//
//  Created by ablai erzhanov on 23.03.2022.
//

import UIKit

protocol PaymentViewDelegate: NSObject {
    func handleViewTap(_ view: PaymentView)
}


class PaymentView: UIView {
    
    public var paymentState: PaymentTypeState = .empty {
        didSet {
            configureView(paymentState: paymentState)
        }
    }
    
    public weak var delegate: PaymentViewDelegate?
    private let paymentTypeLabel = IokaLabel(title: "Выберите способ оплаты", iokaFont: Typography.body, iokaTextColor: IokaColors.grey)
    private let paymentTypeImageView = IokaImageView(imageName: "paymentType")
    private let chevronRightImageView = IokaImageView(imageName: "chevronRight")
    
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
            paymentTypeLabel.textColor = IokaColors.grey
        case .savedCard(let card):
            paymentTypeLabel.text = card.pan_masked.trimPanMasked()
            paymentTypeLabel.textColor = IokaColors.fill2
            guard let paymentSystem = card.payment_system else { return }
            paymentTypeImageView.image = UIImage(named: paymentSystem)
        case .creditCard(let title):
            paymentTypeLabel.text = title
            paymentTypeLabel.textColor = IokaColors.fill2
        case .applePay(let title):
            paymentTypeLabel.text = title
            paymentTypeLabel.textColor = IokaColors.fill2
        case .cash(let title):
            paymentTypeLabel.text = title
            paymentTypeLabel.textColor = IokaColors.fill2
        }
    }
  
    private func setupUI() {
        self.backgroundColor = IokaColors.fill6
        self.layer.cornerRadius = 8
        
        [paymentTypeLabel, paymentTypeImageView, chevronRightImageView].forEach{ self.addSubview($0) }
        
        paymentTypeImageView.anchor(left: self.leftAnchor, bottom: self.bottomAnchor, paddingLeft: 16, paddingBottom: 16, width: 24, height: 24)
        
        paymentTypeLabel.centerY(in: paymentTypeImageView, left: paymentTypeImageView.rightAnchor, paddingLeft: 12)
        
        chevronRightImageView.centerY(in: paymentTypeImageView, right: self.rightAnchor, paddingRight: 16, width: 20, height: 20)
    }
}
