//
//  BankCardView.swift
//  IOKA
//
//  Created by ablai erzhanov on 21.03.2022.
//

import Foundation
import UIKit

protocol BankCardViewDelegate: NSObject {
    func handleViewTap(_ view: BankCardView, isPayWithCashSelected: Bool)
}

class BankCardView: UIView {
    
    let creditCardImageView = IokaImageView(imageName: "Credit-card")
    let saveCardlabel = IokaLabel(title: "Банковской картой", iokaFont: Typography.body, iokaTextColor: IokaColors.fill2)
    let checkImageView = IokaImageView(imageName: "uncheckIcon")
    var isViewSelected: Bool = false
    weak var delegate: BankCardViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(delegate: BankCardViewDelegate) {
        self.init()
        self.delegate = delegate
    }
    
    public func uncheckView() {
        self.checkImageView.image = UIImage(named: "uncheckIcon")
    }
    
    public func checkkView() {
        self.checkImageView.image = UIImage(named: "checkIcon")
    }
    
    public func changeViewSelection() {
        switch isViewSelected {
        case true:
            checkkView()
        case false:
            uncheckView()
        }
    }
    
    private func setActions() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleView)))
    }
    
    @objc private func handleView() {
        self.isViewSelected.toggle()
        changeViewSelection()
        delegate?.handleViewTap(self, isPayWithCashSelected: isViewSelected)
    }
    
    private func setupUI() {
        self.backgroundColor = IokaColors.fill6
        self.layer.cornerRadius = 8
        [creditCardImageView, saveCardlabel, checkImageView].forEach{ self.addSubview($0) }
        
        creditCardImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.height.width.equalTo(24)
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(18)
        }
        
        saveCardlabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(creditCardImageView.snp.trailing).offset(14)
        }
        
        checkImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview().inset(16)
        }
    }
}
