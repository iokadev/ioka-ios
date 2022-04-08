//
//  CVVView.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import UIKit

protocol CVVViewDelegate: NSObject {
    func closeView(_ view: CVVView)
    func makePayment(_ view: CVVView)
}

class CVVView: UIView {
    
    weak var delegate: CVVViewDelegate?
    
    public let cvvTextField = UITextField()
    private let savedCardView = IokaCustomView(backGroundColor: colors.background, cornerRadius: 12)
    private let titleLabel = IokaLabel(title: IokaLocalizable.paymentConfirmation, iokaFont: typography.title, iokaTextColor: colors.text)
    private let closeButton = IokaButton(imageName: "Close")
    private let cardInfoView = IokaCustomView(backGroundColor: colors.fill4, cornerRadius: 12)
    private let cardBrandImageView = IokaImageView()
    private let cardPanMaskedLabel = IokaLabel(iokaFont: typography.body, iokaTextColor: colors.text)
    private let cvvImageView = IokaImageView(imageName: "cvvExplained")
    private let continueButton = IokaButton(iokaButtonState: .enabled, title: IokaLocalizable.continueButton)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setActions()
        cvvTextField.becomeFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configureView(card: GetCardResponse) {
        self.cardPanMaskedLabel.text = card.pan_masked.trimPanMasked()
        guard let paymentSystem = card.payment_system else { return }
        self.cardBrandImageView.image = UIImage(named: paymentSystem)
    }
    
    private func setActions() {
        self.closeButton.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        self.continueButton.addTarget(self, action: #selector(handleContinueButton), for: .touchUpInside)
    }
    
    @objc private func handleCloseButton() {
        delegate?.closeView(self)
    }
    
    @objc private func handleContinueButton() {
        self.continueButton.showLoading()
        delegate?.makePayment(self)
    }
    
    private func setUI() {
        self.backgroundColor = colors.foreground
        self.addSubview(savedCardView)
        cvvTextField.placeholder = "CVV"
        cvvTextField.keyboardType = .numberPad
        cvvTextField.delegate = self
        cvvTextField.isSecureTextEntry = true
        savedCardView.anchor(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 280, paddingLeft: 16, paddingRight: 16, height: 224)
        
        [titleLabel, closeButton, cardInfoView, continueButton].forEach { savedCardView.addSubview($0) }
        
        titleLabel.anchor(top: savedCardView.topAnchor, left: savedCardView.leftAnchor, paddingTop: 24, paddingLeft: 24)
        
        closeButton.anchor(top: savedCardView.topAnchor, right: savedCardView.rightAnchor, paddingTop: 24, paddingRight: 24, width: 24, height: 24)
        
        cardInfoView.anchor(top: titleLabel.bottomAnchor, left: savedCardView.leftAnchor, right: savedCardView.rightAnchor, paddingTop: 24, paddingLeft: 24, paddingRight: 24, height: 56)
        
        continueButton.anchor(top: cardInfoView.bottomAnchor, left: savedCardView.leftAnchor, right: savedCardView.rightAnchor, paddingTop: 16, paddingLeft: 24, paddingRight: 24, height: 56)
        
        [cardBrandImageView, cardPanMaskedLabel, cvvImageView, cvvTextField].forEach { cardInfoView.addSubview($0) }
        
        cardBrandImageView.centerY(in: cardInfoView, left: cardInfoView.leftAnchor, paddingLeft: 16, width: 24, height: 24)
        
        cardPanMaskedLabel.centerY(in: cardInfoView, left: cardBrandImageView.rightAnchor, paddingLeft: 12)
        
        cvvImageView.centerY(in: cardInfoView, right: cardInfoView.rightAnchor, paddingRight: 16, width: 24, height: 24)
        
        cvvTextField.centerY(in: cardInfoView, right: cvvImageView.leftAnchor, paddingRight: 12)
    }
}

extension CVVView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         let newLength = (textField.text ?? "").count + string.count - range.length
        
        if textField == cvvTextField {
            return newLength <= 4
        }
         return true
    }
}

