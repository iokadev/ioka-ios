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
    func getEmitterByBinCode(_ view: CardPaymentView, bin_code : String)
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
        
        payButton.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(keyboardEndFrame.height + 20)
        }
        UIView.animate(withDuration: animationDuration) { [weak self] in
            self?.layoutIfNeeded()
        }
    }
    
    @objc private func handleKeyboardDissapear(notification: Notification) {
        guard let userInfo = notification.userInfo, let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        payButton.snp.updateConstraints { make in
            make.bottom.equalToSuperview().inset(114)
        }
        UIView.animate(withDuration: animationDuration) { [weak self] in
            self?.layoutIfNeeded()
        }
    }
    
    @objc private func handleViewTap() {
        self.endEditing(true)
    }
    
    private func setupUI() {
        self.backgroundColor = CustomColors.fill1
        [titleLabel, closeButton, cardNumberTextField, stackViewForCardInfo, stackViewForCardSaving, payButton, transactionLabel, transactionImageView].forEach{ self.addSubview($0) }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(60)
        }
        
        closeButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(60)
            make.width.height.equalTo(24)
        }
        
        cardNumberTextField.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(titleLabel.snp.bottom).offset(32)
            make.height.equalTo(56)
        }
        
        stackViewForCardInfo.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(cardNumberTextField.snp.bottom).offset(8)
            make.height.equalTo(56)
        }
        
        stackViewForCardSaving.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(stackViewForCardInfo.snp.bottom).offset(8)
        }
        
        payButton.snp.makeConstraints { make in
            make.height.equalTo(56)
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(114)
        }
        
        transactionLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(60)
        }
        
        transactionImageView.snp.makeConstraints { make in
            make.centerY.equalTo(transactionLabel.snp.centerY)
            make.trailing.equalTo(transactionLabel.snp.leading).inset(-8)
            make.width.height.equalTo(24)
        }
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
