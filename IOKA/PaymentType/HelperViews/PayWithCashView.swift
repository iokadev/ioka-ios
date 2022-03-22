//
//  PayWithCashView.swift
//  IOKA
//
//  Created by ablai erzhanov on 21.03.2022.
//

import Foundation
import UIKit

protocol PayWithCashViewDelegate: NSObject {
    func handleViewTap(_ view: PayWithCashView, isPayWithCashSelected: Bool)
}


class PayWithCashView: UIView {
    
    let payWithCashImageView = IokaImageView(imageName: "cash")
    let payWithCashlabel = IokaLabel(title: "Наличными курьеру", iokaFont: Typography.body, iokaTextColor: IokaColors.fill2)
    let checkImageView = IokaImageView(imageName: "uncheckIcon")
    weak var delegate: PayWithCashViewDelegate?
    var isPayWithCashSelected: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(delegate: PayWithCashViewDelegate) {
        self.init()
        setActions()
        self.delegate = delegate
    }
    
    public func uncheckView() {
        self.checkImageView.image = UIImage(named: "uncheckIcon")
    }
    
    public func checkkView() {
        self.checkImageView.image = UIImage(named: "checkIcon")
    }
    
    public func changeViewSelection() {
        switch isPayWithCashSelected {
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
        self.isPayWithCashSelected.toggle()
        changeViewSelection()
        delegate?.handleViewTap(self, isPayWithCashSelected: isPayWithCashSelected)
    }
    
    private func setupUI() {
        self.backgroundColor = IokaColors.fill6
        self.layer.cornerRadius = 8
        [payWithCashImageView, payWithCashlabel, checkImageView].forEach{ self.addSubview($0) }
        
        payWithCashImageView.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
        
        payWithCashlabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.equalToSuperview().inset(18)
            make.leading.equalTo(payWithCashImageView.snp.trailing).offset(14)
        }
        
        checkImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
            make.trailing.equalToSuperview().inset(16)
        }
    }
}
