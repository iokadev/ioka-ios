//
//  DemoAppErrorView.swift
//  IOKA
//
//  Created by ablai erzhanov on 30.03.2022.
//

import UIKit

protocol DemoAppErrorViewDelegate: NSObject {
    func closeErrorView(_ view: DemoAppErrorView)
}

class DemoAppErrorView: UIView {
    
    public weak var delegate: DemoAppErrorViewDelegate?
    public var error: IokaError? {
        didSet {
            configureErrorView(error: error)
        }
    }
    
    private let errorLabel = IokaLabel(iokaFont: Typography.subtitle, iokaTextColor: IOKA.shared.theme.nonadaptableText, iokaTextAlignemnt: .left)
    private let closeButton = IokaButton(imageName: "closeError")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureErrorView(error: IokaError?) {
        
        if let error = error {
            self.errorLabel.text = error.message
            self.backgroundColor = IOKA.shared.theme.error
        } else {
            self.errorLabel.text = "карта удалена"
            self.backgroundColor = IOKA.shared.theme.success
        }
        
    }
    
    private func setActions() {
        closeButton.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
    }
    
    @objc private func handleCloseButton() {
        delegate?.closeErrorView(self)
    }
    
    private func setUI() {
        self.layer.cornerRadius = 12
        [errorLabel, closeButton].forEach{ self.addSubview($0) }
        
        errorLabel.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor,right: self.rightAnchor, paddingTop: 12, paddingLeft: 16,paddingBottom: 12, paddingRight: 48)
        
        closeButton.centerY(in: errorLabel, right: self.rightAnchor, paddingRight: 16, width: 24, height: 24)
    }
}
