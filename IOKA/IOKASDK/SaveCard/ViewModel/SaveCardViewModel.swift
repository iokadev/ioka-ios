//
//  SaveCardViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import Foundation
import UIKit


class SaveCardViewModel {
    
    func saveCard(_ view: SaveCardView, customerId: String, card: Card, completion: @escaping((SaveCardStatus, IokaError?, GetCardResponse?) -> Void)) {
        IokaApi.shared.createBinding(customerId: customerId, card: card) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                view.showErrorView(error: error)
                self.handleSaveButton(view: view, state: .savingFailure)
                completion(.savingFailed, error, nil)
            }
            
            
            guard let result = result else { return }
            
            if let error = result.error {
                view.showErrorView(error: error)
                self.handleSaveButton(view: view, state: .savingFailure)
                completion(.savingFailed, nil, result)
            } else {
                self.handleSaveButton(view: view, state: .savingSuccess)
                completion(.savingSucceed, nil, result)
            }
        }
    }
    
    func handleSaveButton(view: SaveCardView, state: IokaButtonState) {
        DispatchQueue.main.async {
            view.endEditing(true)
            view.saveButton.iokaButtonState = state
        }
    }
    
    func getBrand(partialBin: String, completion: @escaping(GetBrandResponse?) -> Void) {
        IokaApi.shared.getBrand(partialBin: partialBin) { result, error in
            guard error == nil else {
                completion(nil)
                return
            }
            if let result = result { completion(result) }
        }
    }
    
    func getBankEmiiter(binCode: String) {
        IokaApi.shared.getEmitterByBinCode(binCode: binCode.trimEmitterBinCode()) { response, error in
            print("DEBUG: Response is \(response)")
        }
    }
    
    func checkPayButtonState(view: SaveCardView) {
        guard let cardNumberText = view.cardNumberTextField.text else {
            disablePayButton(view)
            return }
        guard let dateExpirationText = view.dateExpirationTextField.text else {
            disablePayButton(view)
            return }
        guard let cvvText = view.cvvTextField.text else {
            disablePayButton(view)
            return }
        
        guard cardNumberText.trimCardNumberText().checkCardNumber() == IokaTextFieldState.correctInputData else {
            disablePayButton(view)
            return }
        guard dateExpirationText.trimDateExpirationText().checkCardExpiration() == IokaTextFieldState.correctInputData else {
            disablePayButton(view)
            return }
        guard cvvText.checkCVV() == IokaTextFieldState.correctInputData else {
            disablePayButton(view)
            return }
        view.saveButton.iokaButtonState = .enabled
    }
    
    private func disablePayButton(_ view: SaveCardView) {
        view.saveButton.iokaButtonState = .disabled
    }
    
    func modifyPaymentTextFields(view: SaveCardView, text : String, textField: UITextField) -> String {
        switch textField {
        case view.cardNumberTextField:
            if text.count == 0 {
                view.isCardBrendSetted = false
                view.cardNumberTextField.cardBrandImageView.image = nil
            }
            if text.count >= 6 {
                self.getBankEmiiter(binCode: text)
            }
            return text.transformCardNumber(trimmedString: text.trimCardNumberText())
        case view.dateExpirationTextField:
            return text.transformExpirationDate(trimmedString: text.trimDateExpirationText())
        case view.cvvTextField:
            return text
        default:
            return text
        }
    }
}
