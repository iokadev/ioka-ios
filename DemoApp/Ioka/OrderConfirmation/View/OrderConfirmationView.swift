//
//  OrderConfirmationView.swift
//  iOKA
//
//  Created by ablai erzhanov on 12.03.2022.
//

import UIKit

internal protocol OrderConfirmationViewDelegate: NSObject {
    func confirmButtonWasPressed(_ orderView: OrderConfirmationView)
    func showPaymentTypeViewController(_ view: OrderConfirmationView)
}

internal class OrderConfirmationView: UIView {
    
    var order: OrderModel? {
        didSet {
            configureView()
            orderInformationView.setUpView(order: order)
        }
    }
    
    weak var delegate: OrderConfirmationViewDelegate?
    
    public lazy var paymentView = PaymentView(delegate: self)
    private let orderTitleLabel = DemoLabel(font: typography.subtitle, textColor: colors.nonadaptableGrey, textAlignment: .center)
    private let orderImageView = DemoImageView(imageName: "productImage", cornerRadius: 8)
    private let orderPriceLabel = DemoLabel(font: typography.heading, textColor: colors.text, textAlignment: .center)
    private let orderInformationView = OrderInformationView()
    private let confirmButton = DemoButton(title: "Оформить")
    private let paymentTypeImageView = DemoImageView(imageName: "paymentType")
    private let seperatorView = DemoCustomView(backGroundColor: colors.secondaryBackground)
    
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
        
    }
    
    private func setupUI() {

        self.backgroundColor = colors.tertiaryBackground
        [orderTitleLabel, orderImageView, orderPriceLabel, orderInformationView, paymentView, confirmButton].forEach{ self.addSubview($0) }
        
        
        orderTitleLabel.anchor(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 116, paddingLeft: 16, paddingRight: 16)
        
        orderImageView.centerX(in: self, top: orderTitleLabel.bottomAnchor, paddingTop: 16, width: 120, height: 120)
        
        orderPriceLabel.anchor(top: orderImageView.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        orderInformationView.anchor(top: orderPriceLabel.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 24, paddingLeft: 16, paddingRight: 16, height: 113)
        
        paymentView.anchor(top: orderInformationView.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 24, paddingLeft: 16, paddingRight: 16, height: 56)
        
        confirmButton.anchor(left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingLeft: 16, paddingBottom: 50, paddingRight: 16, height: 56)
    }
}


extension OrderConfirmationView: PaymentViewDelegate {
    func handleViewTap(_ view: PaymentView) {
        delegate?.showPaymentTypeViewController(self)
    }
}
