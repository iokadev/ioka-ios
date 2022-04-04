//
//  ErrorPopUpView.swift
//  IOKA
//
//  Created by ablai erzhanov on 04.04.2022.
//

import UIKit

protocol ErrorPopUpViewDelegate: NSObject {
    func dismissView(_ view: ErrorPopUpView)
}

class ErrorPopUpView: UIView {
    
    weak var delegate: ErrorPopUpViewDelegate?
    
    private let backgroundView = IokaCustomView(backGroundColor: IOKA.shared.theme.background, cornerRadius: 12)
    private let errorImageview = IokaImageView(imageName: "XCircle")
    private let errorTitleLabel = IokaLabel(title: IokaLocalizable.paymentFailed, iokaFont: Typography.title, iokaTextColor: IOKA.shared.theme.text, iokaTextAlignemnt: .center)
    private let errorDescriptionLabel = IokaLabel(iokaFont: Typography.subtitle, iokaTextColor: IOKA.shared.theme.grey, iokaTextAlignemnt: .center)
    private let tryAgainButton = IokaButton(title: IokaLocalizable.retry, backGroundColor: IOKA.shared.theme.secondary)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureView(error: IokaError) {
        self.errorDescriptionLabel.text = error.message
    }
    
    private func setActions() {
        tryAgainButton.addTarget(self, action: #selector(handleTryAgainButton), for: .touchUpInside
        )
    }
    
    @objc private func handleTryAgainButton() {
        delegate?.dismissView(self)
    }
    
    
    private func setUI() {
        self.backgroundColor = IOKA.shared.theme.foreground
        self.addSubview(backgroundView)
        backgroundView.anchor(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 282, paddingLeft: 40, paddingRight: 40)
        
        [errorImageview, errorTitleLabel, errorDescriptionLabel, tryAgainButton].forEach { backgroundView.addSubview($0) }
        
        errorImageview.centerX(in: backgroundView, top: backgroundView.topAnchor, paddingTop: 24, width: 56, height: 56)
        errorTitleLabel.anchor(top: errorImageview.bottomAnchor, left: backgroundView.leftAnchor, right: backgroundView.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        errorDescriptionLabel.anchor(top: errorTitleLabel.bottomAnchor, left: backgroundView.leftAnchor, right: backgroundView.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        tryAgainButton.anchor(top: errorDescriptionLabel.bottomAnchor, left: backgroundView.leftAnchor, bottom: backgroundView.bottomAnchor, right: backgroundView.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingBottom: 24, paddingRight: 24, height: 56)
    }
}

