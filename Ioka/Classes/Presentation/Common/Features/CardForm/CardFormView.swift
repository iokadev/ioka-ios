//
//  CardPaymentView.swift
//  iOKA
//
//  Created by ablai erzhanov on 27.02.2022.
//

import UIKit


internal protocol CardFormViewDelegate: NSObject {
    func getBrand(_ view: CardFormView, with partialBin: String)
    func getEmitterByBinCode(_ view: CardFormView, with binCode: String)
    func createPaymentOrSaveCard(_ view: CardFormView, cardNumber: String, cvc: String, exp: String)
    func checkCreateButtonState(_ view: CardFormView)
    func closeCardFormView(_ view: CardFormView)
    func modifyPaymentTextFields(_ view: CardFormView, text : String, textField: UITextField) -> String
    func checkTextFieldState(_ view: CardFormView, textField: UITextField)
}

enum CardFormState {
    case payment
    case saving
}

internal enum TextFieldType {
    case cardNumber
    case cvv
    case dateExpiration
}


internal class CardFormView: UIView {

    let titleLabel = IokaLabel(iokaFont: typography.title)
    let closeButton = IokaButton(imageName: "Close")
    let cardNumberTextField = IokaCardNumberTextField(placeHolderType: .cardNumber)
    let dateExpirationTextField = IokaTextField(placeHolderType: .dateExpiration)
    let cvvTextField = IokaTextField(placeHolderType: .cvv)
    let saveCardLabel = IokaLabel(title: IokaLocalizable.saveCard, iokaFont: typography.subtitle)
    let saveCardToggle = UISwitch()
    let createButton = IokaButton(iokaButtonState: .disabled)
    let transactionLabel = IokaLabel(title: IokaLocalizable.transactionsProtected, iokaFont: typography.subtitle, iokaTextColor: colors.success)
    private var transactionImageView = IokaImageView(imageName: "transactionIcon", imageTintColor: colors.success)
    private lazy var stackViewForCardInfo = IokaStackView(views: [dateExpirationTextField, cvvTextField], viewsDistribution: .fillEqually, viewsAxis: .horizontal, viewsSpacing: 8)
    private lazy var stackViewForCardSaving = IokaStackView(views: [saveCardLabel, saveCardToggle], viewsDistribution: .fill, viewsAxis: .horizontal, viewsSpacing: 8)
    private lazy var stackViewForTransaction = IokaStackView(views: [transactionImageView, transactionLabel], viewsDistribution: .equalCentering, viewsAxis: .horizontal, viewsSpacing: 8)
    private lazy var errorView = ErrorToastView()
    let feedbackGenerator = UISelectionFeedbackGenerator()
    
    weak var delegate: CardFormViewDelegate?
    var isCardBrendSetted: Bool = false
    var cardFormState: CardFormState?
    var createButtonBottomConstraint: NSLayoutConstraint?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setActions()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDissapear), name: UIResponder.keyboardWillHideNotification, object: nil)
        [cardNumberTextField, dateExpirationTextField, cvvTextField].forEach { $0.delegate = self }
    }
    
    convenience init(state: CardFormState, price: Int? = nil) {
        self.init()
        self.cardFormState = state
        setupSaveCardUI(price: price)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(error: Error) {
        errorView.show(error: error)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func setActions() {
        [dateExpirationTextField, cardNumberTextField, cvvTextField].forEach{$0.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)}
        
        createButton.addTarget(self, action: #selector(handleCreateButton), for: .touchUpInside)
        
        closeButton.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleViewTap)))
        
        saveCardToggle.addTarget(self, action: #selector(handleSaveCardToggle), for: .allEvents)
    }
    
    @objc private func handleCloseButton() {
        delegate?.closeCardFormView(self)
    }
    
    @objc private func handleCreateButton() {
        createButton.showLoading()
        
        switch createButton.iokaButtonState {
        case .savingSuccess:
            delegate?.closeCardFormView(self)
        case .enabled:
            guard let cardNumber = cardNumberTextField.text?.trimCardNumberText() else { return }
            guard let cvc = cvvTextField.text else { return }
            guard let exp = dateExpirationTextField.text else { return }
            delegate?.createPaymentOrSaveCard(self, cardNumber: cardNumber, cvc: cvc, exp: exp)
            self.endEditing(true)
        default:
            delegate?.checkCreateButtonState(self)
        }
    }
    
    @objc func didChangeText(textField: UITextField) {
        let text = delegate?.modifyPaymentTextFields(self, text: textField.text!, textField: textField)
        textField.text = text
        delegate?.checkCreateButtonState(self)
        delegate?.checkTextFieldState(self, textField: textField)
        guard !cardNumberTextField.isCardBrandSetted else { return }
        delegate?.getBrand(self, with:   cardNumberTextField.text?.trimCardNumberText() ?? "")
    }
    
    @objc private func handleKeyboardAppear(notification: Notification) {
        guard let userInfo = notification.userInfo, let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double, let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        self.layoutIfNeeded()
        
        UIView.animate(withDuration: animationDuration) { [weak self] in
            self?.createButtonBottomConstraint?.constant = -(keyboardEndFrame.height + 20)
            self?.layoutIfNeeded()
        }
    }
    
    @objc private func handleKeyboardDissapear(notification: Notification) {
        guard let userInfo = notification.userInfo, let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        self.layoutIfNeeded()
        
        UIView.animate(withDuration: animationDuration) { [weak self] in
            guard let self = self else { return }
            self.createButtonBottomConstraint?.constant = -114
            self.layoutIfNeeded()
        }
    }
    
    @objc private func handleViewTap() {
        self.endEditing(true)
    }
    
    @objc private func handleSaveCardToggle() {
        feedbackGenerator.selectionChanged()
    }
    
    private func setupUI() {
        self.backgroundColor = colors.background
        
        [titleLabel, closeButton, cardNumberTextField, stackViewForCardInfo, createButton, stackViewForTransaction].forEach{ self.addSubview($0) }
        self.addSubview(self.errorView)
        
        titleLabel.centerX(in: self, top: self.topAnchor, paddingTop: 60)
        
        closeButton.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 60, paddingLeft: 16, width: 24, height: 24)
        
        cardNumberTextField.anchor(top: titleLabel.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 32, paddingLeft: 16, paddingRight: 16, height: 56)
        
        stackViewForCardInfo.anchor(top: cardNumberTextField.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 56)
        
        createButton.anchor(left: self.leftAnchor, right: self.rightAnchor, paddingLeft: 16, paddingRight: 16, height: 56)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        self.createButtonBottomConstraint = createButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -114)
        self.createButtonBottomConstraint?.isActive = true
        
        transactionImageView.setDimensions(width: 24, height: 24)
        stackViewForTransaction.centerX(in: self, bottom: self.bottomAnchor, paddingBottom: 60)

        self.errorView.anchor(left: self.leftAnchor, bottom: self.createButton.topAnchor, right: self.rightAnchor, paddingLeft: 16, paddingBottom: 8, paddingRight: 16)
        
    }
    
    private func setupSaveCardUI(price: Int?) {
        guard let cardFormState = cardFormState else { return }
        
        switch cardFormState {
        case .payment:
            guard let price = price else { return }
            let locale = IokaLocalizable.priceTng
            self.titleLabel.text = String(format: locale, String(price))
            self.addSubview(stackViewForCardSaving)
            stackViewForCardSaving.anchor(top: stackViewForCardInfo.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 40)
        case .saving:
            self.titleLabel.text = IokaLocalizable.save
        }
        
        setupCreateButton(price: price)
    }
    
    private func setupCreateButton(price: Int?) {
        guard let cardFormState = cardFormState else { return }
        
        switch cardFormState {
        case .payment:
            guard let price = price else { return }
            createButton.setTitle("\(IokaLocalizable.pay) \(price) ₸", for: .normal)
        case .saving:
            createButton.setTitle(IokaLocalizable.save, for: .normal)
        }

    }
}

extension CardFormView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let textField = textField as? IokaTextField else { return }
        textField.iokaTextFieldState = .startTyping
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.checkCreateButtonState(self)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         let newLength = (textField.text ?? "").count + string.count - range.length
         if textField == cardNumberTextField {
             return newLength <= 23
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
