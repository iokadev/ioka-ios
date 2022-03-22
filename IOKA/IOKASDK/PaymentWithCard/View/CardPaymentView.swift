//
//  CardPaymentView.swift
//  iOKA
//
//  Created by ablai erzhanov on 27.02.2022.
//

import Foundation
import UIKit
import SnapKit


protocol CardPaymentViewDelegate: NSObject {
    func getBrand(_ view: UIView, with partialBin: String)
    func getEmitterByBinCode(_ view: UIView, with binCode: String)
    func createCardPayment(_ view: UIView, cardNumber: String, cvc: String, exp: String)
    func checkPayButtonState(_ view: CardPaymentView)
    func modifyPaymentTextFields(_ view: CardPaymentView, text : String, textField: UITextField) -> String
}


class CardPaymentView: UIView {

    let titleLabel = CustomLabel(title: "К оплате 12 560", customFont: Typography.title)
    let closeButton = CustomButton(image: UIImage(named: "Close"))
    let cardNumberTextField = CustomCardNumberTextField(placeHolderType: .cardNumber)
    let dateExpirationTextField = CustomTextField(placeHolderType: .dateExpiration)
    let cvvTextField = CustomTextField(placeHolderType: .cvv)
    let saveCardLabel = CustomLabel(title: "Сохранить карту", customFont: Typography.subtitle)
    let saveCardToggle = UISwitch()
    let payButton = CustomButton(customButtonState: .disabled, title: "Оплатить")
    let transactionLabel = CustomLabel(title: "Все транзакции защищены", customFont: Typography.subtitle, customTextColor: CustomColors.success)
    private var transactionImageView = CustomImageView(imageName: "transactionIcon", imageTintColor: CustomColors.success)
    private lazy var stackViewForCardInfo = CustomStackView(views: [dateExpirationTextField, cvvTextField], viewsDistribution: .fillEqually, viewsAxis: .horizontal, viewsSpacing: 8)
    private lazy var stackViewForCardSaving = CustomStackView(views: [saveCardLabel, saveCardToggle], viewsDistribution: .fillEqually, viewsAxis: .horizontal, viewsSpacing: 12)
    
    weak var cardPaymentViewDelegate: CardPaymentViewDelegate?
    var isCardBrendSetted: Bool = false
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setActions()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDissapear), name: UIResponder.keyboardWillHideNotification, object: nil)
        [cardNumberTextField, dateExpirationTextField, cvvTextField].forEach { $0.delegate = self }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setActions() {
        [dateExpirationTextField, cardNumberTextField, cvvTextField].forEach{$0.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)}
        
        payButton.addTarget(self, action: #selector(handlePayButton), for: .touchUpInside)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleViewTap)))
    }
    
    @objc private func handlePayButton() {
        payButton.showLoading()
        guard payButton.customButtonState == .enabled else { return }
        guard let cardNumber = cardNumberTextField.text?.trimCardNumberText() else { return }
        guard let cvc = cvvTextField.text else { return }
        guard let exp = dateExpirationTextField.text else { return }
        cardPaymentViewDelegate?.createCardPayment(self, cardNumber: cardNumber, cvc: cvc, exp: exp)
    }
    
    @objc func didChangeText(textField: UITextField) {
        let text = cardPaymentViewDelegate?.modifyPaymentTextFields(self, text: textField.text!, textField: textField)
        textField.text = text
        cardPaymentViewDelegate?.checkPayButtonState(self)
        guard !cardNumberTextField.isCardBrandSetted else { return }
        cardPaymentViewDelegate?.getBrand(self, with:   cardNumberTextField.text?.trimCardNumberText() ?? "")
    }
    
    @objc private func handleKeyboardAppear(notification: Notification) {
        guard let userInfo = notification.userInfo, let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double, let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        self.layoutIfNeeded()
        payButton.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(keyboardEndFrame.height + 20)
        }
        
        UIView.animate(withDuration: animationDuration) { [weak self] in
            self?.payButton.anchor(left: self?.leftAnchor, bottom: self?.bottomAnchor, right: self?.rightAnchor, paddingLeft: 16, paddingBottom: keyboardEndFrame.height + 20, paddingRight: 16, height: 56)
            self?.payButton.setNeedsUpdateConstraints()
            self?.layoutIfNeeded()
        }
    }
    
    @objc private func handleKeyboardDissapear(notification: Notification) {
        guard let userInfo = notification.userInfo, let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        self.layoutIfNeeded()
        payButton.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(114)
        }
        
        UIView.animate(withDuration: animationDuration) { [weak self] in
            guard let self = self else { return }
            self.layoutIfNeeded()
        }
    }
    
    @objc private func handleViewTap() {
        self.endEditing(true)
    }
    
    private func setupUI() {
        self.backgroundColor = CustomColors.fill1
        [titleLabel, closeButton, cardNumberTextField, stackViewForCardInfo, stackViewForCardSaving, payButton, transactionLabel, transactionImageView].forEach{ self.addSubview($0) }
        
        titleLabel.centerX(in: self, top: self.topAnchor, paddingTop: 60)
        
        closeButton.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 60, paddingLeft: 16, width: 24, height: 24)
        
        cardNumberTextField.anchor(top: titleLabel.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 32, paddingLeft: 16, paddingRight: 16, height: 56)
        
        stackViewForCardInfo.anchor(top: cardNumberTextField.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 56)
        
        stackViewForCardSaving.anchor(top: stackViewForCardInfo.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 40)
        
        payButton.anchor(left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingLeft: 16, paddingBottom: 114, paddingRight: 16, height: 56)
        
        transactionLabel.centerX(in: self, bottom: self.bottomAnchor, paddingBottom: 60)
        
        transactionImageView.centerY(in: transactionLabel, right: transactionLabel.leftAnchor, paddingRight: 8, width: 24, height: 24)
    }
}

extension CardPaymentView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let textField = textField as? CustomTextField else { return }
        textField.customTextFieldState = .startTyping
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let textField = textField as? CustomTextField else { return }
        switch textField {
        case cardNumberTextField:
            guard let trimmedText = textField.text?.trimCardNumberText() else { return }
            cardNumberTextField.customTextFieldState = trimmedText.checkCardNumber()
        case dateExpirationTextField:
            guard let trimmedText = textField.text?.trimDateExpirationText() else { return }
            dateExpirationTextField.customTextFieldState = trimmedText.checkCardExpiration()
        case cvvTextField:
            guard let trimmedText = textField.text?.trimCardNumberText() else { return }
            cvvTextField.customTextFieldState = trimmedText.checkCVV()
        default:
            print("Any other implementation if you would like to add")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         let newLength = (textField.text ?? "").count + string.count - range.length
         if textField == cardNumberTextField {
             return newLength <= 19
         }
        
        if textField == dateExpirationTextField {
            return newLength <= 5
        }
        
        if textField == cvvTextField {
            return newLength <= 3
        }
         return true
    }
}
