//
//  PayWithCashView.swift
//  IOKA
//
//  Created by ablai erzhanov on 21.03.2022.
//


import UIKit

internal protocol PayWithCashViewDelegate: NSObject {
    func handleViewTap(_ view: PayWithCashView, isPayWithCashSelected: Bool)
}


internal class PayWithCashView: UIView {
    
    let payWithCashImageView = DemoImageView(imageName: "cash")
    let payWithCashlabel = DemoLabel(title: "Наличными курьеру", font: typography.body, textColor: colors.text)
    let checkImageView = DemoImageView(imageName: "uncheckIcon")
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
        self.checkImageView.image = DemoImages.uncheckIcon
    }
    
    public func checkkView() {
        self.checkImageView.image = DemoImages.checkIcon
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
        self.backgroundColor = colors.quaternaryBackground
        self.layer.cornerRadius = 8
        [payWithCashImageView, payWithCashlabel, checkImageView].forEach{ self.addSubview($0) }
        
        payWithCashImageView.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 18, paddingLeft: 16, width: 24, height: 24)
        payWithCashImageView.centerY(in: self)
        
        payWithCashlabel.centerY(in: self, left: payWithCashImageView.rightAnchor, paddingLeft: 14)
        
        checkImageView.centerY(in: self, right: self.rightAnchor, paddingRight: 16, width: 24, height: 24)
        
        
    }
}
