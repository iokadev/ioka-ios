//
//  CardFormViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 03.04.2022.
//

import UIKit


class t {
    
    
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
//            print("DEBUG: Response is \(response)")
        }
    }
    
    func checkPayButtonState(view: CardFormView) {
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
        view.createButton.iokaButtonState = .enabled
    }
    
    private func disablePayButton(_ view: CardFormView) {
        view.createButton.iokaButtonState = .disabled
    }
    
    func modifyPaymentTextFields(view: CardFormView, text : String, textField: UITextField) -> String {
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
