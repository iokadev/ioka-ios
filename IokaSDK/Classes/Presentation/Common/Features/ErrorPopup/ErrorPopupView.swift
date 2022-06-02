//
//  ErrorPopupView.swift
//  IOKA
//
//  Created by ablai erzhanov on 04.04.2022.
//

import UIKit

internal protocol ErrorPopupViewDelegate: NSObject {
    func close()
}

internal class ErrorPopupView: UIView {
    
    weak var delegate: ErrorPopupViewDelegate?
    
    private let backgroundView = IokaCustomView(backGroundColor: colors.background, cornerRadius: 12)
    private let errorImageview = IokaImageView(imageName: "XCircle")
    private let errorTitleLabel = IokaLabel(title: IokaLocalizable.paymentFailed, iokaFont: typography.title, iokaTextColor: colors.text, iokaTextAlignemnt: .center)
    private let errorDescriptionLabel = IokaLabel(iokaFont: typography.subtitle, iokaTextColor: colors.nonadaptableGrey, iokaTextAlignemnt: .center)
    private let tryAgainButton = IokaButton(title: IokaLocalizable.retry, backgroundColor: colors.secondary)
    
    let error: Error
    
    init(error: Error) {
        self.error = error
        super.init(frame: .zero)

        setUI()
        setActions()
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setActions() {
        tryAgainButton.addTarget(self, action: #selector(handleTryAgainButton), for: .touchUpInside)
    }
    
    @objc private func handleTryAgainButton() {
        delegate?.close()
    }
    
    private func setUI() {
        self.backgroundColor = colors.foreground
        self.addSubview(backgroundView)
        backgroundView.centerY(in: self, left: self.leftAnchor, paddingLeft: 40, right: self.rightAnchor, paddingRight: 40)
        
        [errorImageview, errorTitleLabel, errorDescriptionLabel, tryAgainButton].forEach { backgroundView.addSubview($0) }
        
        errorImageview.centerX(in: backgroundView, top: backgroundView.topAnchor, paddingTop: 24, width: 56, height: 56)
        errorTitleLabel.anchor(top: errorImageview.bottomAnchor, left: backgroundView.leftAnchor, right: backgroundView.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24)
        errorDescriptionLabel.anchor(top: errorTitleLabel.bottomAnchor, left: backgroundView.leftAnchor, right: backgroundView.rightAnchor, paddingTop: 8, paddingLeft: 24, paddingRight: 24)
        tryAgainButton.anchor(top: errorDescriptionLabel.bottomAnchor, left: backgroundView.leftAnchor, bottom: backgroundView.bottomAnchor, right: backgroundView.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingBottom: 24, paddingRight: 24, height: 56)
    }
    
    private func configure() {
        self.errorDescriptionLabel.text = error.localizedDescription
    }
}

