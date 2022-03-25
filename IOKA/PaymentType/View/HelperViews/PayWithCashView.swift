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
    let payWithCashlabel = IokaLabel(title: "Наличными курьеру", iokaFont: Typography.body, iokaTextColor: DemoAppColors.fill2)
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
        self.checkImageView.image = DemoAppImages.uncheckIcon
    }
    
    public func checkkView() {
        self.checkImageView.image = DemoAppImages.checkIcon
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
        self.backgroundColor = DemoAppColors.fill6
        self.layer.cornerRadius = 8
        [payWithCashImageView, payWithCashlabel, checkImageView].forEach{ self.addSubview($0) }
        
        payWithCashImageView.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 18, paddingLeft: 16, width: 24, height: 24)
        payWithCashImageView.centerY(in: self)
        
        payWithCashlabel.centerY(in: self, left: payWithCashImageView.rightAnchor, paddingLeft: 14)
        
        checkImageView.centerY(in: self, right: self.rightAnchor, paddingRight: 16, width: 24, height: 24)
        
        
    }
}
