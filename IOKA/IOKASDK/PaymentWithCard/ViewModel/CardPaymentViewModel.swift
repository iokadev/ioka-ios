//
//  PaymentWithCardViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 13.03.2022.
//

import Foundation
import UIKit


class CardPaymentViewModel {
    
    weak var delegate: CardPaymentNavigationDelegate?
    
    
    func completeCardPaymentFlow(status: PaymentResult, error: IokaError?, response: CardPaymentResponse?) {
        delegate?.completeCardPaymentFlow(status: status, error: error, response: response)
    }
    
    func completeCardPaymentFlow() {
        delegate?.completeCardPaymentFlow()
    }
    
    
    func createCardPayment(order_id: String, card: Card, completion: @escaping((PaymentResult, IokaError?, CardPaymentResponse?) -> Void)) {
        IokaApi.shared.createCardPayment(orderId: order_id, card: card) { [weak self] result, error in
            guard let _ = self else { return }
            guard error == nil else { completion(.paymentFailed, error, nil)
                return
            }
            guard let result = result else { return }
            
            guard result.error == nil else { completion(.paymentFailed, nil, result)
                return
            }
            
            completion(.paymentSucceed, nil, result)
            
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
    
    func checkPayButtonState(view: CardPaymentView) {
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
        view.payButton.iokaButtonState = .enabled
    }
    
    private func disablePayButton(_ view: CardPaymentView) {
        view.payButton.iokaButtonState = .disabled
    }
    
    func modifyPaymentTextFields(view: CardPaymentView, text : String, textField: UITextField) -> String {
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
