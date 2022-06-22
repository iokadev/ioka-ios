//
//  CardPaymentView.swift
//  iOKA
//
//  Created by ablai erzhanov on 27.02.2022.
//

import UIKit


internal protocol CardFormViewDelegate: NSObject {
    func showCardScanner(_ view: CardFormView)
    func cardFormView(textFieldDidChange cardFormView: CardFormView)
}

internal class CardFormView: UIView {
    let cardNumberTextField = IokaCardNumberTextField()
    let dateExpirationTextField = IokaTextField(inputType: .dateExpiration)
    let cvvTextField = IokaCVVTextFIeld()
    private let tipView = TooltipView()
    private lazy var stackViewForCardInfo = IokaStackView(views: [dateExpirationTextField, cvvTextField], viewsDistribution: .fillEqually, viewsAxis: .horizontal, viewsSpacing: 8)

    weak var delegate: CardFormViewDelegate?
    var isCardBrendSetted: Bool = false
    var viewModel: CardFormViewModel?
    var paymentSystem: PaymentSystem?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        self.cardNumberTextField.isUserInteractionEnabled = true
        self.cardNumberTextField.scannerDelegate = self
        setupUI()
        setActions()
        [cardNumberTextField, dateExpirationTextField, cvvTextField].forEach { $0.delegate = self }
    }

    convenience init(viewModel: CardFormViewModel) {
        self.init(frame: CGRect())
        self.viewModel = viewModel
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func getEmitterByBinCode(text: String) {
        viewModel?.getEmitterByBinCode(binCode: text) { [weak self] bankEmitter in
            if let bankEmitter = bankEmitter {
                self?.viewModel?.isEmitterSetted = true
                self?.cardNumberTextField.setBankEmitterIcon(imageName: bankEmitter.emitter_code)
            }
        }
    }

    func getPaymentSystem(text: String) {
        viewModel?.getPaymentSystem(partialBin: text) { [weak self] paymentSystem in
            if let paymentSystem = paymentSystem {
                self?.paymentSystem = PaymentSystem(rawValue: paymentSystem)
                self?.cardNumberTextField.setCardBrandIcon(imageName: paymentSystem)
            } else {
                self?.cardNumberTextField.removeCardBrandIcon()
            }
        }
    }

    private func setActions() {
        [dateExpirationTextField, cardNumberTextField, cvvTextField].forEach{$0.addTarget(self, action: #selector(didChangeText(textField:)), for: .editingChanged)}

        cvvTextField.iconContainerView
            .addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCVVTooltip)))
    }

    @objc private func handleCVVTooltip() {
        showTooltip()
    }

    private func showTooltip() {
        tipView.performShow()
    }

    @objc func didChangeText(textField: UITextField) {
        guard let viewModel = viewModel else {
            return
        }

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

        delegate?.cardFormView(textFieldDidChange: self)

        guard textField === cardNumberTextField,
              text.count > 0,
              cardNumberTextField.isCardBrandSetted == false else {
            if text.count == 0 {
                cardNumberTextField.removeCardBrandIcon()
                cardNumberTextField.removeBankEmitterIcon()
            }
            return
        }

       getPaymentSystem(text: text)
       getEmitterByBinCode(text: text)
    }

    func handleViewTap() {
        self.endEditing(true)
        if self.subviews.contains(tipView) {
            tipView.performDismiss()
        }
    }

    private func setupUI() {

        [cardNumberTextField, stackViewForCardInfo].forEach{ self.addSubview($0) }

        cardNumberTextField.anchor(top: self.topAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 16, paddingRight: 16, height: 56)
        self.bringSubviewToFront(cardNumberTextField)

        stackViewForCardInfo.anchor(top: cardNumberTextField.bottomAnchor, left: self.leftAnchor, right: self.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingRight: 16, height: 56)

        let tipWidth: CGFloat = 168

        self.addSubview(tipView)
        tipView.anchor(bottom: cvvTextField.cvvTooltipImageView.topAnchor, right: self.rightAnchor, paddingBottom: 0, paddingRight: 16, width: tipWidth)
    }
}

extension CardFormView: UITextFieldDelegate,
                            IokaCardNumberTextFieldDelegate {
    func scannerDidPressed(_ textField: IokaCardNumberTextField) {
        delegate?.showCardScanner(self)
    }

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
             return CreditCardValidatorr.getPaymentSystemLength(newLength: newLength, paymentSystem: paymentSystem)
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
