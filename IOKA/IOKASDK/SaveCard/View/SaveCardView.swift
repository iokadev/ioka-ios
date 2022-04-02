//
//  SaveCardView.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import UIKit


protocol SaveCardViewDelegate: NSObject {
    func getBrand(_ view: SaveCardView, with partialBin: String)
    func getEmitterByBinCode(_ view: SaveCardView, with binCode: String)
    func createCardPayment(_ view: SaveCardView, cardNumber: String, cvc: String, exp: String)
    func checkPayButtonState(_ view: SaveCardView)
    func close(_ view: SaveCardView)
    func modifyPaymentTextFields(_ view: SaveCardView, text : String, textField: UITextField) -> String
}


class SaveCardView: UIView {

    let titleLabel = IokaLabel(title: "Новая карта", iokaFont: Typography.title)
    let closeButton = IokaButton(imageName: "Close")
    let cardNumberTextField = IokaCardNumberTextField(placeHolderType: .cardNumber)
    let dateExpirationTextField = IokaTextField(placeHolderType: .dateExpiration)
    let cvvTextField = IokaTextField(placeHolderType: .cvv)
    let saveButton = IokaButton(iokaButtonState: .disabled, title: IokaLocalizable.save)
    let transactionLabel = IokaLabel(title: IokaLocalizable.transactionsProtected, iokaFont: Typography.subtitle, iokaTextColor: IOKA.shared.theme.success)
    private var transactionImageView = IokaImageView(imageName: "transactionIcon", imageTintColor: IOKA.shared.theme.success)
    private lazy var stackViewForCardInfo = IokaStackView(views: [dateExpirationTextField, cvvTextField], viewsDistribution: .fillEqually, viewsAxis: .horizontal, viewsSpacing: 8)
    private lazy var errorView = ErrorView()
    
    weak var saveCardViewDelegate: SaveCardViewDelegate?
    var isCardBrendSetted: Bool = false
    var saveButtonBottomConstraint: NSLayoutConstraint?
    
    
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
        
        saveButton.addTarget(self, action: #selector(handleSaveButton), for: .touchUpInside)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleViewTap)))
        
        self.closeButton.addTarget(self, action: #selector(handleCloseButtonTap), for: .touchUpInside)
    }
    
    @objc private func handleSaveButton() {
        
        switch saveButton.iokaButtonState {
        case .savingSuccess:
            saveCardViewDelegate?.close(self)
        case .enabled:
            saveButton.showLoading()
            guard let cardNumber = cardNumberTextField.text?.trimCardNumberText() else { return }
            guard let cvc = cvvTextField.text else { return }
            guard let exp = dateExpirationTextField.text else { return }
            saveCardViewDelegate?.createCardPayment(self, cardNumber: cardNumber, cvc: cvc, exp: exp)
        default :
            saveCardViewDelegate?.checkPayButtonState(self)
        }
    }
    
    @objc private func didChangeText(textField: UITextField) {
        let text = saveCardViewDelegate?.modifyPaymentTextFields(self, text: textField.text!, textField: textField)
        textField.text = text
        saveCardViewDelegate?.checkPayButtonState(self)
        guard !cardNumberTextField.isCardBrandSetted else { return }
        saveCardViewDelegate?.getBrand(self, with:   cardNumberTextField.text?.trimCardNumberText() ?? "")
    }
    
    @objc private func handleKeyboardAppear(notification: Notification) {
        guard let userInfo = notification.userInfo, let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double, let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        self.layoutIfNeeded()
       
        UIView.animate(withDuration: animationDuration) { [weak self] in
            self?.saveButtonBottomConstraint?.constant = -(keyboardEndFrame.height + 20)
            self?.layoutIfNeeded()
        }
    }
    
    @objc private func handleKeyboardDissapear(notification: Notification) {
        guard let userInfo = notification.userInfo, let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        self.layoutIfNeeded()
        
        UIView.animate(withDuration: animationDuration) { [weak self] in
            guard let self = self else { return }
            self.saveButtonBottomConstraint?.constant = -114
            self.layoutIfNeeded()
        }
    }
    
    @objc private func handleViewTap() {
        self.endEditing(true)
    }
    
    @objc private func handleCloseButtonTap() {
        saveCardViewDelegate?.close(self)
    }
    
    private func setupUI() {
        self.backgroundColor = IOKA.shared.theme.background
        [titleLabel, closeButton, cardNumberTextField, stackViewForCardInfo, saveButton, transactionLabel, transactionImageView].forEach{ self.addSubview($0) }
        
        titleLabel.centerX(in: self, top: self.topAnchor, paddingTop: 60)
        
        closeButton.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 60, paddingLeft: 16, width: 24, height: 24)
        
        cardNumberTextField.anchor(top: titleLabel.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 32, paddingLeft: 16, paddingRight: 16, height: 56)
        
        stackViewForCardInfo.anchor(top: cardNumberTextField.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 56)
        
        saveButton.anchor(left: self.leftAnchor, right: self.rightAnchor, paddingLeft: 16, paddingRight: 16, height: 56)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        self.saveButtonBottomConstraint = saveButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -114)
        self.saveButtonBottomConstraint?.isActive = true
        
        transactionLabel.centerX(in: self, bottom: self.bottomAnchor, paddingBottom: 60)
        
        transactionImageView.centerY(in: transactionLabel, right: transactionLabel.leftAnchor, paddingRight: 8, width: 24, height: 24)
    }
}

extension SaveCardView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let textField = textField as? IokaTextField else { return }
        textField.iokaTextFieldState = .startTyping
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let textField = textField as? IokaTextField else { return }
        switch textField {
        case cardNumberTextField:
            guard let trimmedText = textField.text?.trimCardNumberText() else { return }
            cardNumberTextField.iokaTextFieldState = trimmedText.checkCardNumber()
        case dateExpirationTextField:
            guard let trimmedText = textField.text?.trimDateExpirationText() else { return }
            dateExpirationTextField.iokaTextFieldState = trimmedText.checkCardExpiration()
        case cvvTextField:
            guard let trimmedText = textField.text?.trimCardNumberText() else { return }
            cvvTextField.iokaTextFieldState = trimmedText.checkCVV()
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
            return newLength <= 4
        }
         return true
    }
}

extension SaveCardView: ErrorViewDelegate {
    
    public func showErrorView(error: IokaError) {
        DispatchQueue.main.async {
            self.errorView.error = error
            self.errorView.delegate = self
            self.addSubview(self.errorView)
            self.errorView.anchor(left: self.leftAnchor, bottom: self.saveButton.topAnchor, right: self.rightAnchor, paddingLeft: 16, paddingBottom: 8, paddingRight: 16)
        }
    }
    
    func closeErrorView(_ view: ErrorView) {
        DispatchQueue.main.async {
            self.errorView.removeFromSuperview()
        }
    }
    
    
}
