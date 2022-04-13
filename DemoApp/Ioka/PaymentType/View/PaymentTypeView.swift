//
//  PaymentTypeView.swift
//  IOKA
//
//  Created by ablai erzhanov on 13.03.2022.
//

import Foundation
import UIKit
import Ioka

internal enum PaymentTypeState {
    case applePay(title: String)
    case savedCard(card: SavedCardDTO)
    case creditCard(title: String)
    case cash(title: String)
    case empty
}

internal protocol PaymentTypeViewDelegate: NSObject {
    func saveButtonWasPressed(_ paymentTypeView: PaymentTypeView, state: PaymentTypeState)
    func closeButtonWasPressed(_ paymentTypeView: PaymentTypeView)
}

internal class PaymentTypeView: UIView {
    

    weak var delegate: PaymentTypeViewDelegate?
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.isScrollEnabled = false
        tv.backgroundColor = colors.tertiaryBackground
        tv.layer.cornerRadius = 8
        tv.rowHeight = 56
        
        return tv
    }()
    lazy var bankCardView = BankCardView(delegate: self)
    lazy var payWithCashView = PayWithCashView(delegate: self)
    var closeButton = DemoButton(imageName: "chevronLeft", backGroundColor: .clear)
    var titleLabel = DemoLabel(title: "Способ оплаты", font: typography.title, textColor: colors.text, textAlignment: .center)
    var saveButton = DemoButton(title: "Сохранить")
    var paymentTypeState: PaymentTypeState?
    var heightConstraint: NSLayoutConstraint?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func reloadTableView(models: [SavedCardDTO]) {
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.tableView.layoutIfNeeded()
                self?.heightConstraint?.constant = CGFloat(56 * models.count) + 56
                self?.updateConstraints()
            }
        }
    }
    
    private func setupActions() {
        self.saveButton.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        self.closeButton.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
    }
    
    @objc private func handleSaveButton() {
        guard let paymentTypeState = paymentTypeState else { return }
        delegate?.saveButtonWasPressed(self, state: paymentTypeState)
    }
    
    @objc private func handleCloseButton() {
        delegate?.closeButtonWasPressed(self)
    }
    
    public func setupUI(models: [SavedCardDTO]) {
        self.backgroundColor = colors.secondaryBackground
        [tableView, bankCardView, payWithCashView, closeButton, titleLabel, saveButton].forEach{ self.addSubview($0) }
        
        closeButton.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 60, paddingLeft: 16, width: 24, height: 24)

        titleLabel.center(in: self, in: closeButton)
        
        tableView.anchor(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 116, paddingLeft: 16, paddingRight: 16)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.heightConstraint = tableView.heightAnchor.constraint(equalToConstant: CGFloat(56 * models.count) + 56)
        self.heightConstraint?.isActive = true
        
        bankCardView.anchor(top: tableView.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 25, paddingLeft: 16, paddingRight: 16)
        
        payWithCashView.anchor(top: bankCardView.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 25, paddingLeft: 16, paddingRight: 16)

        saveButton.anchor(left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingLeft: 16, paddingBottom: 50, paddingRight: 16, height: 56)
    }
}

extension PaymentTypeView: PayWithCashViewDelegate, BankCardViewDelegate, ApplePayCellDelegate, CardPaymentCellDelegate {
    
    func handleViewTap(_ view: ApplePayCell, isPayWithCashSelected: Bool) {
        guard isPayWithCashSelected else { return }
        self.paymentTypeState = .applePay(title: view.applePayLabel.text!)
        bankCardView.uncheckView()
        payWithCashView.uncheckView()
        bankCardView.isViewSelected = false
        payWithCashView.isPayWithCashSelected = false
    }
    
    func handleViewTap(_ view: CardPaymentCell, isPayWithCashSelected: Bool, cardResponse: SavedCardDTO) {
        guard isPayWithCashSelected else { return }
        self.paymentTypeState = .savedCard(card: cardResponse)
        bankCardView.uncheckView()
        payWithCashView.uncheckView()
        bankCardView.isViewSelected = false
        payWithCashView.isPayWithCashSelected = false
    }
    
    func handleViewTap(_ view: PayWithCashView, isPayWithCashSelected: Bool) {
        guard isPayWithCashSelected else { return }
        self.paymentTypeState = .cash(title: view.payWithCashlabel.text!)
        bankCardView.uncheckView()
        bankCardView.isViewSelected = false
    }
    
    func handleViewTap(_ view: BankCardView, isPayWithCashSelected: Bool) {
        guard isPayWithCashSelected else { return }
        self.paymentTypeState = .creditCard(title: view.saveCardlabel.text!)
        payWithCashView.uncheckView()
        payWithCashView.isPayWithCashSelected = false
    }
}
