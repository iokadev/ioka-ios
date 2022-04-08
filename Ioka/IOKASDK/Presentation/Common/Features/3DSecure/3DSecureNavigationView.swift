//
//  IokaBrowserNavigationView.swift
//  IOKA
//
//  Created by ablai erzhanov on 31.03.2022.
//

import UIKit

protocol IokaBrowserNavigationViewDelegate: NSObject {
    func closeBrowser()
}


class IokaBrowserNavigationView: UIView {
    
    weak var delegate: IokaBrowserNavigationViewDelegate?
    
    private let title = IokaLabel(title: IokaLocalizable.paymentConfirmation, iokaFont: typography.title, iokaTextColor: colors.text)
    private let closeButton = IokaButton(imageName: "Close")
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupActions() {
        closeButton.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
    }
    
    @objc private func handleCloseButton() {
        delegate?.closeBrowser()
    }
    
    
    private func setupUI() {
        [title, closeButton].forEach { self.addSubview($0) }
        
        closeButton.anchor(left: self.leftAnchor, bottom: self.bottomAnchor, paddingLeft: 16, paddingBottom: 16, width: 24, height: 24)
        title.center(in: self, in: closeButton)
    }
}
