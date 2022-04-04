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
        delegate?.completeCardPaymentFlow(status: status, error: error, response: response)
    }
    
    func completeCardPaymentFlow() {
        delegate?.completeCardPaymentFlow()
    }
    
    func createCardPayment(order_id: String, card: Card, completion: @escaping((PaymentResult, IokaError?, CardPaymentResponse?) -> Void)) {
        IokaApi.shared.createCardPayment(orderId: order_id, card: card) { [weak self] result, error in
            guard let self = self else { return }
            guard error == nil else {
                self.cardPaymentFailure?(error)
                return
            }
            guard let result = result else { return }
            
            guard result.error == nil else { completion(.paymentFailed, nil, result)
                return
            }
            
            completion(.paymentSucceed, nil, result)
            
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
