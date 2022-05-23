//
//  PaymentMethodsView.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import UIKit
import PassKit

protocol PaymentMethodsViewDelegate: NSObject {
    func paymentMethodsView(createPayment paymentMethodsView: PaymentMethodsView, cardNumber: String, cvc: String, exp: String, save: Bool)
    func paymentMethodsView(showCardScanner paymentMethodsView: PaymentMethodsView)
    func paymentMethodsView(closePaymentMethodsView paymentMethodsView: PaymentMethodsView)
    func paymentMethodsView(applePayButtonDidPressed paymentMethodsView: PaymentMethodsView)
}


class PaymentMethodsView: UIView {

    let order: Order
    let viewModel: CardFormViewModel
    weak var delegate: PaymentMethodsViewDelegate?

    lazy var cardFormView = CardFormView(viewModel: viewModel)
    private let saveCardToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.onTintColor = colors.primary

        return toggle
    }()
    private let saveCardLabel = IokaLabel(title: IokaLocalizable.saveCard, iokaFont: typography.subtitle)
    private lazy var stackViewForCardSaving = IokaStackView(views: [saveCardLabel, saveCardToggle], viewsDistribution: .fill, viewsAxis: .horizontal, viewsSpacing: 8)
    private let createButton = IokaButton(state: .disabled)
    private lazy var errorView = ErrorToastView()
    private let transactionLabel = IokaLabel(title: IokaLocalizable.transactionsProtected, iokaFont: typography.subtitle, iokaTextColor: colors.success)
    private var transactionImageView = IokaImageView(imageName: "Transaction", imageTintColor: colors.success)
    private lazy var stackViewForTransaction = IokaStackView(views: [transactionImageView, transactionLabel], viewsDistribution: .equalCentering, viewsAxis: .horizontal, viewsSpacing: 8)
    private let feedbackGenerator = UISelectionFeedbackGenerator()

    private var createButtonBottomConstraint: NSLayoutConstraint?
    private var hasApplePay: Bool
    private var applePayButton = PKPaymentButton(paymentButtonType: .plain, paymentButtonStyle: .black)
    private var payCardLabel = IokaLabel(title: IokaLocalizable.orPayCard, iokaFont: typography.subtitleSmall, iokaTextColor: colors.nonadaptableGrey, iokaTextAlignemnt: .center)
    private var seperatorViewLeft = IokaCustomView(backGroundColor: colors.nonadaptableGrey, cornerRadius: 0)
    private var seperatorViewRight = IokaCustomView(backGroundColor: colors.nonadaptableGrey, cornerRadius: 0)


    init(order: Order, viewModel: CardFormViewModel, hasApplePay: Bool) {
        self.order = order
        self.viewModel = viewModel
        self.hasApplePay = hasApplePay
        super.init(frame: .zero)
        cardFormView.delegate = self
        setUI()
        setActions()
        setupPayButton()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDissapear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupPayButton() {
        createButton.title = "\(IokaLocalizable.pay) \(order.price) ₸"
    }

    func show(error: Error) {
        errorView.show(error: error)
    }

    func startLoading() {
        createButton.iokaState = .loading
        [cardFormView.cardNumberTextField, cardFormView.dateExpirationTextField, cardFormView.cvvTextField].forEach {
            $0.isUserInteractionEnabled = false
        }
    }

    func stopLoading() {
        //        createButton.iokaState = .enabled
        [cardFormView.cardNumberTextField, cardFormView.dateExpirationTextField, cardFormView.cvvTextField].forEach {
            $0.isUserInteractionEnabled = true
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func setActions() {
        createButton.addTarget(self, action: #selector(handleCreateButton), for: .touchUpInside)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleViewTap)))
        saveCardToggle.addTarget(self, action: #selector(handleSaveCardToggle), for: .allEvents)
        applePayButton.addTarget(self, action: #selector(handleAplePayButton), for: .touchUpInside)
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

    @objc private func handleCreateButton() {
        self.endEditing(true)

        guard let cardNumber = cardFormView.cardNumberTextField.text?.trimCardNumberText(),
              let cvc = cardFormView.cvvTextField.text,
              let exp = cardFormView.dateExpirationTextField.text else { return }
        delegate?.paymentMethodsView(createPayment: self, cardNumber: cardNumber, cvc: cvc, exp: exp, save: saveCardToggle.isOn)
    }

    @objc private func handleAplePayButton() {
        self.delegate?.paymentMethodsView(applePayButtonDidPressed: self)
    }

    @objc private func handleViewTap() {
        cardFormView.handleViewTap()
    }

    @objc private func handleSaveCardToggle() {
        feedbackGenerator.selectionChanged()
    }

    private func setUI() {
        self.backgroundColor = colors.background
        [cardFormView, createButton, stackViewForTransaction, errorView].forEach { self.addSubview($0) }

        if hasApplePay {
            [applePayButton, payCardLabel, seperatorViewLeft, seperatorViewRight].forEach { self.addSubview($0) }
            applePayButton.anchor(top: self.safeAreaTopAnchor, left: self.leftAnchor, right: self.rightAnchor,paddingTop: 32, paddingLeft: 16, paddingRight: 16, height: 50)
            payCardLabel.centerX(in: self, top: applePayButton.bottomAnchor, paddingTop: 24)
            seperatorViewLeft.centerY(in: payCardLabel, left: self.leftAnchor, paddingLeft: 16, right: payCardLabel.leftAnchor, paddingRight: 8, height: 1)
            seperatorViewRight.centerY(in: payCardLabel, left: payCardLabel.rightAnchor, paddingLeft: 8, right: self.rightAnchor, paddingRight: 16, height: 1)
            cardFormView.anchor(top: applePayButton.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor,paddingTop: 64, paddingLeft: 0, paddingRight: 0, height: 120)
        } else {
            cardFormView.anchor(top: self.safeAreaTopAnchor, left: self.leftAnchor, right: self.rightAnchor,paddingTop: 32, paddingLeft: 0, paddingRight: 0, height: 120)
        }

        if order.hasCustomerId {
            self.addSubview(stackViewForCardSaving)
            stackViewForCardSaving.anchor(top: cardFormView.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 40)
        }

        createButton.anchor(left: self.leftAnchor, right: self.rightAnchor, paddingLeft: 16, paddingRight: 16, height: 56)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        self.createButtonBottomConstraint = createButton.bottomAnchor.constraint(equalTo: self.safeAreaBottomAnchor, constant: -64)
        self.createButtonBottomConstraint?.isActive = true

        transactionImageView.setDimensions(width: 24, height: 24)
        stackViewForTransaction.centerX(in: self, bottom: self.safeAreaBottomAnchor, paddingBottom: 24)

        errorView.anchor(left: self.leftAnchor, bottom: self.createButton.topAnchor, right: self.rightAnchor, paddingLeft: 16, paddingBottom: 8, paddingRight: 16)
    }
}

extension PaymentMethodsView: CardFormViewDelegate {

    func showCardScanner(_ view: CardFormView) {
        delegate?.paymentMethodsView(showCardScanner: self)
    }

    func cardFormView(textFieldDidChange cardFormView: CardFormView) {
        createButton.iokaState = viewModel.checkPayButtonState(cardNumberText: cardFormView.cardNumberTextField.text ?? "",
                                      dateExpirationText: cardFormView.dateExpirationTextField.text ?? "",
                                      cvvText: cardFormView.cvvTextField.text ?? "")
    }
}
