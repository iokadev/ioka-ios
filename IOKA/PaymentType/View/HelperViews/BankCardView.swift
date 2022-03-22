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
        
        creditCardImageView.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 18, paddingLeft: 16, width: 24, height: 24)
        creditCardImageView.centerY(in: self)
        
        saveCardlabel.centerY(in: self, left: creditCardImageView.rightAnchor, paddingLeft: 14)
        
        checkImageView.centerY(in: self, right: self.rightAnchor, paddingRight: 16, width: 24, height: 24)
    }
}
