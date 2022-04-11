//
//  DemoAppErrorView.swift
//  IOKA
//
//  Created by ablai erzhanov on 30.03.2022.
//

import UIKit

internal protocol DemoAppErrorViewDelegate: NSObject {
    func closeErrorView(_ view: DemoAppErrorView)
}

internal class DemoAppErrorView: UIView {
    
    public weak var delegate: DemoAppErrorViewDelegate?
    public var error: Error? {
        didSet {
            configureErrorView(error: error)
        }
    }
    
    private let errorLabel = IokaLabel(iokaFont: typography.subtitle, iokaTextColor: colors.nonadaptableText, iokaTextAlignemnt: .left)
    private let closeButton = IokaButton(imageName: "closeError")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureErrorView(error: Error?) {
        
        if let error = error {
            self.errorLabel.text = error.localizedDescription
            self.backgroundColor = DemoAppColors.error
        } else {
            self.errorLabel.text = "карта удалена"
            self.backgroundColor = DemoAppColors.success
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
