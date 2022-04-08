//
//  SaveCardViewController.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import UIKit

enum SaveCardStatus {
    case savingSucceed
    case savingFailed
}


class SaveCardViewController: IokaViewController {
    
    public var onButtonPressed: ((PaymentResult, IokaError?, CardPaymentResponse?) -> Void)?
    private lazy var contentView = CardFormView(state: .saving)
    var viewModel: SaveCardViewModel!
    var customerId: String!
    let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
   

    override func viewDidLoad() {
        super.viewDidLoad()
        contentView.delegate = self
        handleBindings()
    }
    
    override func loadView() {
        self.view = contentView
    }
    
    func handleBindings() {
        viewModel.errorCompletion = { [weak self] error in
            guard let self = self else { return }
            self.showError(error: error)
        }
        
        viewModel.successCompletion = { [weak self] in
            guard let self = self else { return }
            self.handleSaveButton(state: .savingSuccess)
            self.feedbackGenerator.impactOccurred()
        }
        
        viewModel.cardBrandCompletion = { [weak self] cardBrand in
            guard let self = self, let cardBrand = cardBrand else { return }
            self.contentView.cardNumberTextField.setCardBrandIcon(imageName: cardBrand.brand.rawValue)
        }
    }
    
    func showError(error: Error) {
        contentView.showErrorView(error: error)
        handleSaveButton(state: .savingFailure)
    }
    
    func handleSaveButton(state: IokaButtonState) {
        self.contentView.endEditing(true)
        self.contentView.createButton.iokaButtonState = state
    }
}

extension SaveCardViewController: CardFormViewDelegate {
    
    func closeCardFormView(_ view: CardFormView) {
        self.viewModel.delegate?.dismissSaveCardViewController()
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
        
        viewModel.checkCreateButtonState(cardNumberText: cardNumberText, dateExpirationText: dateExpirationText, cvvText: cvvText) { [weak self] buttonState in
            guard let _ = self else { return }
            view.createButton.iokaButtonState = buttonState
        }
    }
    
    func getBrand(_ view: CardFormView, with partialBin: String) {
        viewModel.getBrand(partialBin: partialBin)
    }
    
    func createPaymentOrSaveCard(_ view: CardFormView, cardNumber: String, cvc: String, exp: String) {
        let card = Card(pan: cardNumber, exp: exp, cvc: cvc)
        
        viewModel.saveCard(card: card)
    }
}
