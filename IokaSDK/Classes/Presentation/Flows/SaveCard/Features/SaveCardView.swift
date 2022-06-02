//
//  SaveCardView.swift
//  Ioka
//
//  Created by ablai erzhanov on 04.05.2022.
//

import UIKit

protocol SaveCardViewDelegate: NSObject {
    func saveCardView(saveCard saveCardView: SaveCardView, cardNumber: String, cvc: String, exp: String, save: Bool)
    func saveCardView(showCardScanner saveCardView: SaveCardView)
    func saveCardView(closeSaveCardView saveCardView: SaveCardView)
}


class SaveCardView: UIView {

    // MARK: - Properties
    let viewModel: CardFormViewModel
    weak var delegate: SaveCardViewDelegate?

    lazy var cardFormView = CardFormView(viewModel: viewModel)

    private let createButton = IokaButton(state: .disabled)
    private lazy var errorView = ErrorToastView()

    private var createButtonBottomConstraint: NSLayoutConstraint?


    // MARK: - Lifecycle
    init(viewModel: CardFormViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupSaveButton()
        setupUI()
        setActions()
        cardFormView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDissapear), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Public Methods
    public func show(error: Error) {
        errorView.show(error: error)
    }

    public func startLoading() {
        createButton.iokaState = .loading
        [cardFormView.cardNumberTextField,
         cardFormView.dateExpirationTextField,
         cardFormView.cvvTextField].forEach {
            $0.isUserInteractionEnabled = false
        }
    }

    public func stopLoading() {
        createButton.iokaState = .enabled
        [cardFormView.cardNumberTextField,
         cardFormView.dateExpirationTextField,
         cardFormView.cvvTextField].forEach {
            $0.isUserInteractionEnabled = true
        }
    }

    public func showSavingSuccess() {
        UINotificationFeedbackGenerator().notificationOccurred(.success)
        createButton.iokaState = .success
        [cardFormView.cardNumberTextField,
         cardFormView.dateExpirationTextField,
         cardFormView.cvvTextField].forEach {
            $0.isUserInteractionEnabled = false
        }
    }

    // MARK: - Actions
    private func setActions() {
        createButton.addTarget(self, action: #selector(handleCreateButton), for: .touchUpInside)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleViewTap)))
    }

    @objc private func handleCreateButton() {
        self.endEditing(true)

        switch createButton.iokaState {
        case .success:
            delegate?.saveCardView(closeSaveCardView: self)
        case .enabled:
            guard let cardNumber = cardFormView.cardNumberTextField.text?.trimCardNumberText(),
                  let cvc = cardFormView.cvvTextField.text,
                  let exp = cardFormView.dateExpirationTextField.text else { return }
            delegate?.saveCardView(saveCard: self, cardNumber: cardNumber, cvc: cvc, exp: exp, save: false)
        default:
            break
        }
    }

    @objc private func handleViewTap() {
        cardFormView.handleViewTap()
    }

    // MARK: - Keyboard
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


    // MARK: - Configuration

    /// Save Button Configuartion
    private func setupSaveButton() {
        createButton.title = IokaLocalizable.saveCard
    }

    /// Setup UI
    private func setupUI() {
        self.backgroundColor = colors.background
        [cardFormView, createButton, errorView].forEach { self.addSubview($0) }

        cardFormView.anchor(top: self.safeAreaTopAnchor, left: self.leftAnchor, right: self.rightAnchor,paddingTop: 32, paddingLeft: 0, paddingRight: 0, height: 120)

        createButton.anchor(left: self.leftAnchor, right: self.rightAnchor, paddingLeft: 16, paddingRight: 16, height: 56)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        self.createButtonBottomConstraint = createButton.bottomAnchor.constraint(equalTo: self.safeAreaBottomAnchor, constant: -64)
        self.createButtonBottomConstraint?.isActive = true

        errorView.anchor(left: self.leftAnchor, bottom: self.createButton.topAnchor, right: self.rightAnchor, paddingLeft: 16, paddingBottom: 8, paddingRight: 16)
    }

}

extension SaveCardView: CardFormViewDelegate {
    func showCardScanner(_ view: CardFormView) {
        delegate?.saveCardView(showCardScanner: self)
    }

    func cardFormView(textFieldDidChange cardFormView: CardFormView) {
        createButton.iokaState = viewModel.checkPayButtonState(cardNumberText: cardFormView.cardNumberTextField.text ?? "",
                                      dateExpirationText: cardFormView.dateExpirationTextField.text ?? "",
                                      cvvText: cardFormView.cvvTextField.text ?? "")
    }
}
