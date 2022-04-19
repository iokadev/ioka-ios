//
//  CardPaymentView.swift
//  iOKA
//
//  Created by ablai erzhanov on 27.02.2022.
//

import UIKit


internal protocol CardFormViewDelegate: NSObject {
    func createPaymentOrSaveCard(_ view: CardFormView, cardNumber: String, cvc: String, exp: String, save: Bool)
    func closeCardFormView(_ view: CardFormView)
}

enum CardFormState {
    case payment(order: Order)
    case saving
}

internal class CardFormView: UIView {

    let cardNumberTextField = IokaCardNumberTextField()
    let dateExpirationTextField = IokaTextField(inputType: .dateExpiration)
    let cvvTextField = IokaTextField(inputType: .cvv)
    let saveCardLabel = IokaLabel(title: IokaLocalizable.saveCard, iokaFont: typography.subtitle)
    let saveCardToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = colors.primary
        
        return toggle
    }()
    
    let createButton = IokaButton(iokaButtonState: .disabled)
    let transactionLabel = IokaLabel(title: IokaLocalizable.transactionsProtected, iokaFont: typography.subtitle, iokaTextColor: colors.success)
    private var transactionImageView = IokaImageView(imageName: "Transaction", imageTintColor: colors.success)
    private lazy var stackViewForCardInfo = IokaStackView(views: [dateExpirationTextField, cvvTextField], viewsDistribution: .fillEqually, viewsAxis: .horizontal, viewsSpacing: 8)
    private lazy var stackViewForCardSaving = IokaStackView(views: [saveCardLabel, saveCardToggle], viewsDistribution: .fill, viewsAxis: .horizontal, viewsSpacing: 8)
    private lazy var stackViewForTransaction = IokaStackView(views: [transactionImageView, transactionLabel], viewsDistribution: .equalCentering, viewsAxis: .horizontal, viewsSpacing: 8)
    private lazy var errorView = ErrorToastView()
    let feedbackGenerator = UISelectionFeedbackGenerator()
    
    weak var delegate: CardFormViewDelegate?
    var isCardBrendSetted: Bool = false
    let cardFormState: CardFormState
    let viewModel: CardFormViewModel
    
    var createButtonBottomConstraint: NSLayoutConstraint?
    
    init(state: CardFormState, viewModel: CardFormViewModel) {
        self.cardFormState = state
        self.viewModel = viewModel
        
        super.init(frame: .zero)
        
        setupUI()
        setActions()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDissapear), name: UIResponder.keyboardWillHideNotification, object: nil)
        [cardNumberTextField, dateExpirationTextField, cvvTextField].forEach { $0.delegate = self }

        setupSaveCardUI()
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
                
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleViewTap)))
        
        saveCardToggle.addTarget(self, action: #selector(handleSaveCardToggle), for: .allEvents)
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
            delegate?.createPaymentOrSaveCard(self, cardNumber: cardNumber, cvc: cvc, exp: exp, save: saveCardToggle.isOn)
            self.endEditing(true)
        default:
            break
        }
    }
    
    @objc func didChangeText(textField: UITextField) {
        let (text, validationState): (String, ValidationState) = {
            let text = textField.text ?? ""
            switch textField {
            case cardNumberTextField:
                return (viewModel.transformCardNumber(text), viewModel.checkCardNumber(text))
            case dateExpirationTextField:
                return (viewModel.transformExpirationDate(text), viewModel.checkCardExpiration(text))
            case cvvTextField:
                return (text, viewModel.checkCVV(text))
            default:
                return (text, .valid)
            }
        }()
        
        textField.text = text
        (textField as? IokaTextField)?.iokaState = validationState == .invalid ? .invalid : .active
        
        createButton.iokaButtonState = viewModel.checkPayButtonState(cardNumberText: cardNumberTextField.text ?? "",
                                                                     dateExpirationText: dateExpirationTextField.text ?? "",
                                                                     cvvText: cvvTextField.text ?? "")

        guard textField === cardNumberTextField,
              text.count > 0,
              !cardNumberTextField.isCardBrandSetted else {
                  return
              }
        
        viewModel.getPaymentSystem(partialBin: text) { [weak self] paymentSystem in
            if let paymentSystem = paymentSystem {
                self?.cardNumberTextField.setCardBrandIcon(imageName: paymentSystem)
            }
        }
    }
    
    @objc private func handleKeyboardAppear(notification: Notification) {
        guard let userInfo = notification.userInfo, let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double, let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        self.layoutIfNeeded()
        
        createButtonBottomConstraint?.constant = -(keyboardEndFrame.height - safeAreaInsets.bottom + 20)
        
        UIView.animate(withDuration: animationDuration) {
            self.layoutIfNeeded()
        }
    }
    
    @objc private func handleKeyboardDissapear(notification: Notification) {
        guard let userInfo = notification.userInfo, let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        
        self.layoutIfNeeded()
        
        createButtonBottomConstraint?.constant = -64

        UIView.animate(withDuration: animationDuration) {
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
        
        [cardNumberTextField, stackViewForCardInfo, createButton, stackViewForTransaction].forEach{ self.addSubview($0) }
        self.addSubview(self.errorView)
        
        cardNumberTextField.anchor(top: self.safeAreaTopAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 32, paddingLeft: 16, paddingRight: 16, height: 56)
        
        stackViewForCardInfo.anchor(top: cardNumberTextField.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 56)
        
        createButton.anchor(left: self.leftAnchor, right: self.rightAnchor, paddingLeft: 16, paddingRight: 16, height: 56)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        self.createButtonBottomConstraint = createButton.bottomAnchor.constraint(equalTo: self.safeAreaBottomAnchor, constant: -64)
        self.createButtonBottomConstraint?.isActive = true
        
        transactionImageView.setDimensions(width: 24, height: 24)
        stackViewForTransaction.centerX(in: self, bottom: self.safeAreaBottomAnchor, paddingBottom: 24)

        self.errorView.anchor(left: self.leftAnchor, bottom: self.createButton.topAnchor, right: self.rightAnchor, paddingLeft: 16, paddingBottom: 8, paddingRight: 16)
        
    }
    
    private func setupSaveCardUI() {
        switch cardFormState {
        case .payment(let order):
            if order.hasCustomerId {
                self.addSubview(stackViewForCardSaving)
                stackViewForCardSaving.anchor(top: stackViewForCardInfo.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 40)
            }
        case .saving:
            break
        }
        
        setupCreateButton()
    }
    
    private func setupCreateButton() {
        switch cardFormState {
        case .payment(let order):
            createButton.setTitle("\(IokaLocalizable.pay) \(order.price) ₸", for: .normal)
        case .saving:
            createButton.setTitle(IokaLocalizable.save, for: .normal)
        }

    }
}

extension CardFormView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let textField = textField as? IokaTextField else { return }
        
        if textField.iokaState == .inactive {
            textField.iokaState = .active
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let textField = textField as? IokaTextField else { return }
        
        if textField.iokaState == .active {
            textField.iokaState = .inactive
        }
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
