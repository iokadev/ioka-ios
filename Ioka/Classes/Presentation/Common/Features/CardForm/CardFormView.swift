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
    private let cardNumberTextField = IokaCardNumberTextField()
    private let dateExpirationTextField = IokaTextField(inputType: .dateExpiration)
    private let cvvTextField = IokaTextField(inputType: .cvv)
    private let saveCardLabel = IokaLabel(title: IokaLocalizable.saveCard, iokaFont: typography.subtitle)
    private let saveCardToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = colors.primary
        
        return toggle
    }()
    
    private let createButton = IokaButton(state: .disabled)
    private let transactionLabel = IokaLabel(title: IokaLocalizable.transactionsProtected, iokaFont: typography.subtitle, iokaTextColor: colors.success)
    private var transactionImageView = IokaImageView(imageName: "Transaction", imageTintColor: colors.success)
    private lazy var stackViewForCardInfo = IokaStackView(views: [dateExpirationTextField, cvvTextField], viewsDistribution: .fillEqually, viewsAxis: .horizontal, viewsSpacing: 8)
    private lazy var stackViewForCardSaving = IokaStackView(views: [saveCardLabel, saveCardToggle], viewsDistribution: .fill, viewsAxis: .horizontal, viewsSpacing: 8)
    private lazy var stackViewForTransaction = IokaStackView(views: [transactionImageView, transactionLabel], viewsDistribution: .equalCentering, viewsAxis: .horizontal, viewsSpacing: 8)
    private lazy var errorView = ErrorToastView()
    private let feedbackGenerator = UISelectionFeedbackGenerator()
    
    weak var delegate: CardFormViewDelegate?
    var isCardBrendSetted: Bool = false
    let cardFormState: CardFormState
    let viewModel: CardFormViewModel
    
    private var createButtonBottomConstraint: NSLayoutConstraint?
    
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
    
    func startLoading() {
        createButton.iokaState = .loading
        [cardNumberTextField, dateExpirationTextField, cvvTextField, saveCardToggle].forEach {
            $0.isUserInteractionEnabled = false
        }
    }
    
    func stopLoading() {
        createButton.iokaState = .enabled
        [cardNumberTextField, dateExpirationTextField, cvvTextField, saveCardToggle].forEach {
            $0.isUserInteractionEnabled = true
        }
    }
    
    func showSavingSuccess() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        createButton.iokaState = .success
        [cardNumberTextField, dateExpirationTextField, cvvTextField, saveCardToggle].forEach {
            $0.isUserInteractionEnabled = false
        }
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
        self.endEditing(true)
        
        switch createButton.iokaState {
        case .success:
            delegate?.closeCardFormView(self)
        case .enabled:
            guard let cardNumber = cardNumberTextField.text?.trimCardNumberText(),
                  let cvc = cvvTextField.text,
                  let exp = dateExpirationTextField.text else { return }
            delegate?.createPaymentOrSaveCard(self, cardNumber: cardNumber, cvc: cvc, exp: exp, save: saveCardToggle.isOn)
        default:
            break
        }
    }
    
    @objc func didChangeText(textField: UITextField) {
        let oldText = textField.text ?? ""

        let (text, validationState): (String, ValidationState) = {
            switch textField {
            case cardNumberTextField:
                return (viewModel.transformCardNumber(oldText), viewModel.checkCardNumber(oldText))
            case dateExpirationTextField:
                return (viewModel.transformExpirationDate(oldText), viewModel.checkCardExpiration(oldText))
            case cvvTextField:
                return (oldText, viewModel.checkCVV(oldText))
            default:
                return (oldText, .valid)
            }
        }()
        
        if text != oldText, let selection = textField.selectedTextRange {
            let diff = oldText.count - text.count
            let cursorPosition = textField.offset(from: textField.beginningOfDocument, to: selection.start) - diff
            
            textField.text = text
            
            if let newPosition = textField.position(from: textField.beginningOfDocument, offset: cursorPosition) {
                textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
            }
        }

        (textField as? IokaTextField)?.iokaState = validationState == .invalid ? .invalid : .active
        
        createButton.iokaState = viewModel.checkPayButtonState(cardNumberText: cardNumberTextField.text ?? "",
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
            createButton.title = "\(IokaLocalizable.pay) \(order.price) ₸"
        case .saving:
            createButton.title = IokaLocalizable.save
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
