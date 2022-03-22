//
//  PaymentTypeView.swift
//  IOKA
//
//  Created by ablai erzhanov on 13.03.2022.
//

import Foundation
import UIKit

enum PaymentTypeState {
    case applePay
    case savedCard
    case creditCard
    case payWithCash
}

protocol PaymentTypeViewDelegate: NSObject {
    func saveButtonWasPressed(_ paymentTypeView: PaymentTypeView)
}

class PaymentTypeView: UIView {
    

    weak var delegate: PaymentTypeViewDelegate?
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.isScrollEnabled = false
        tv.backgroundColor = IokaColors.fill6
        tv.layer.cornerRadius = 8
        return tv
    }()
    lazy var bankCardView = BankCardView(delegate: self)
    lazy var payWithCashView = PayWithCashView(delegate: self)
    var closeButton = IokaButton(image: UIImage(named: "chevronLeft"))
    var titleLabel = IokaLabel(title: "Способ оплаты", iokaFont: Typography.title, iokaTextColor: IokaColors.fill2, iokaTextAlignemnt: .center)
    var saveButton = IokaButton(iokaButtonState: .enabled, title: "Сохранить")
    var paymentTypeState: PaymentTypeState?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupActions() {
        self.saveButton.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
    }
    
    @objc private func handleSaveButton() {
        guard let paymentTypeState = paymentTypeState else { return }
        delegate?.saveButtonWasPressed(self)
    }
    
    public func setupUI(models: [GetCardResponse]) {
        self.backgroundColor = IokaColors.fill5
        [tableView, bankCardView, payWithCashView, closeButton, titleLabel, saveButton].forEach{ self.addSubview($0) }
        
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(116)
            make.height.equalTo(56 * models.count + 56)
        }
        
        bankCardView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(tableView.snp.bottom).offset(25)
        }
        
        payWithCashView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(bankCardView.snp.bottom).offset(25)
        }
        
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.width.height.equalTo(24)
            make.top.equalToSuperview().offset(60)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(closeButton.snp.centerY)
        }
        
        saveButton.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(50)
        }
    }
}

extension PaymentTypeView: PayWithCashViewDelegate, BankCardViewDelegate, ApplePayCellDelegate, CardPaymentCellDelegate {
    func handleViewTap(_ view: ApplePayCell, isPayWithCashSelected: Bool) {
        guard isPayWithCashSelected else { return }
//        tableView.cell
        bankCardView.uncheckView()
        payWithCashView.uncheckView()
        bankCardView.isViewSelected = false
        payWithCashView.isPayWithCashSelected = false
    }
    
    func handleViewTap(_ view: CardPaymentCell, isPayWithCashSelected: Bool) {
        bankCardView.uncheckView()
        payWithCashView.uncheckView()
        bankCardView.isViewSelected = false
        payWithCashView.isPayWithCashSelected = false
    }
    
    func handleViewTap(_ view: PayWithCashView, isPayWithCashSelected: Bool) {
        bankCardView.uncheckView()
        bankCardView.isViewSelected = false
    }
    
    func handleViewTap(_ view: BankCardView, isPayWithCashSelected: Bool) {
        self.paymentTypeState = .creditCard
        payWithCashView.uncheckView()
        payWithCashView.isPayWithCashSelected = false
    }
}


