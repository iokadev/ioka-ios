//
//  PaymentWithCardViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 13.03.2022.
//

import Foundation
import UIKit


class CardPaymentViewModel {
    
    var delegate: CardPaymentNavigationDelegate?
    var childViewModel = CardFormViewModel()
    var cardPaymentFailure: ((IokaError?) -> Void)?
    
    func completeCardPaymentFlow(status: PaymentResult, error: IokaError?, response: CardPaymentResponse?) {
        DispatchQueue.main.async {
            self.delegate?.completeCardPaymentForm(status: status, error: error, response: response)
        }
    }
    
    func completeCardPaymentFlow() {
        delegate?.completeCardPaymentForm()
    }
    
    func createCardPayment(order_id: String, card: Card) {
        IokaApi.shared.createCardPayment(orderId: order_id, card: card) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let cardPaymentResponse):
                if let error = cardPaymentResponse.error {
                    self.completeCardPaymentFlow(status: .paymentFailed, error: error, response: cardPaymentResponse)
                } else {
                    self.completeCardPaymentFlow(status: .paymentSucceed, error: nil, response: cardPaymentResponse)
                }
            case .failure(let error):
                self.cardPaymentFailure?(error)
            }
        }
    }
    
    func checkTextFieldState(text: String, type: TextFieldType) -> IokaTextFieldState {
        childViewModel.checkTextFieldState(text: text, type: type)
    }
    
    func getBrand(partialBin: String, completion: @escaping(GetBrandResponse?) -> Void) {
        childViewModel.getBrand(partialBin: partialBin) { result in
            completion(result)
        }
    }
    
    func getBankEmiiter(binCode: String) {
        
    }
    
    func checkCreateButtonState(cardNumberText: String, dateExpirationText: String, cvvText: String, completion: @escaping(IokaButtonState) -> Void) {
        
        childViewModel.checkPayButtonState(cardNumberText: cardNumberText, dateExpirationText: dateExpirationText, cvvText: cvvText) { [weak self] buttonState in
            guard let _ = self else { return }
            completion(buttonState)
        }
    }
    
    func modifyPaymentTextFields(text : String, textFieldType: TextFieldType) -> String {
        return childViewModel.modifyPaymentTextFields(text: text, textFieldType: textFieldType)
    }
    
    
}
