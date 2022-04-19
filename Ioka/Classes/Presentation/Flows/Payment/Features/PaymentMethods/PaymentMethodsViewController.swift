//
//  PaymentMethodsViewController.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import UIKit

internal class PaymentMethodsViewController: UIViewController {
    
    private lazy var contentView = CardFormView(state: .payment, price: viewModel.order.price)
    var viewModel: PaymentMethodsViewModel!
    var theme: IokaTheme!
    
    override func loadView() {
        self.view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
        setupNavigationItem()
        
        viewModel.cardPaymentFailure = { [weak self] error in
            if let error = error {
                self?.showError(error)
            }
        }
    }
    
    private func setupNavigationItem() {
        setupNavigationItem(title: String(format: IokaLocalizable.priceTng, String(viewModel.order.price)),
                            closeButtonTarget: self,
                            closeButtonAction: #selector(closeButtonTapped))
    }
    
    @objc func closeButtonTapped() {
        viewModel.delegate?.paymentMethodsDidCancel()
    }
    
    func handlePayButton(state: IokaButtonState) {
        self.contentView.endEditing(true)
        self.contentView.createButton.iokaButtonState = state
        self.contentView.createButton.hideLoading(showTitle: true)
    }
    
    func showError(_ error: Error) {
        contentView.show(error: error)
        handlePayButton(state: .enabled)
        contentView.createButton.hideLoading(showTitle: true)
    }
}

extension PaymentMethodsViewController: CardFormViewDelegate {
    
    func closeCardFormView(_ view: CardFormView) {
        // вызывается только при сохранении
    }
    
    func getEmitterByBinCode(_ view: CardFormView, with binCode: String) {
        viewModel.getBankEmiiter(binCode: binCode)
    }
    
    func modifyPaymentTextFields(_ view: CardFormView, text: String, textField: UITextField) -> String {
        switch textField {
        case view.cardNumberTextField:
            return viewModel.modifyPaymentTextFields(text: text, textFieldType: .cardNumber)
        case view.dateExpirationTextField:
            return viewModel.modifyPaymentTextFields(text: text, textFieldType: .dateExpiration)
        case view.cvvTextField:
            return viewModel.modifyPaymentTextFields(text: text, textFieldType: .cvv)
        default:
            return text
        }
    }
    
    func checkTextFieldState(_ view: CardFormView, textField: UITextField) {
        guard let textField = textField as? IokaTextField else { return }
        switch textField {
        case view.cardNumberTextField:
            guard let text = textField.text else { return }
            textField.iokaTextFieldState = viewModel.checkTextFieldState(text: text, type: .cardNumber)
        case view.dateExpirationTextField:
            guard let text = textField.text else { return }
            textField.iokaTextFieldState = viewModel.checkTextFieldState(text: text, type: .dateExpiration)
        case view.cvvTextField:
            guard let text = textField.text else { return }
            textField.iokaTextFieldState = viewModel.checkTextFieldState(text: text, type: .cvv)
        default:
            textField.iokaTextFieldState = .nonActive
        }
    }
    
    func checkCreateButtonState(_ view: CardFormView) {
        
        guard let cardNumberText = view.cardNumberTextField.text else { view.createButton.iokaButtonState = .disabled
            return
        }
        guard let dateExpirationText = view.dateExpirationTextField.text else { view.createButton.iokaButtonState = .disabled
            return
        }
        guard let cvvText = view.cvvTextField.text else { view.createButton.iokaButtonState = .disabled
            return
        }
        
        viewModel.checkCreateButtonState(cardNumberText: cardNumberText, dateExpirationText: dateExpirationText, cvvText: cvvText) { state in
            view.createButton.iokaButtonState = state
        }
    }
    
    func getBrand(_ view: CardFormView, with partialBin: String) {
        viewModel.getBrand(partialBin: partialBin) { result in
            if let result = result {
                DispatchQueue.main.async {
                    self.contentView.cardNumberTextField.setCardBrandIcon(imageName: result.brand.rawValue)
                }
            }
        }
    }
    
    func createPaymentOrSaveCard(_ view: CardFormView, cardNumber: String, cvc: String, exp: String, save: Bool) {
        let card = CardParameters(pan: cardNumber, exp: exp, cvc: cvc, save: save)
        viewModel.createCardPayment(card: card)
    }
}
