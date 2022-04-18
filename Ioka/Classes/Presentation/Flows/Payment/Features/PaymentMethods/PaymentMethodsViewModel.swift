//
//  PaymentMethodsViewModel.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import Foundation


internal protocol PaymentMethodsNavigationDelegate: AnyObject {
    func paymentMethodsDidCancel()
    func paymentMethodsDidSucceed()
    func paymentMethodsDidRequire3DSecure(action: Action, payment: Payment)
    func paymentMethodsDidFail(declineError: Error)
}


internal class PaymentMethodsViewModel {
    
    weak var delegate: PaymentMethodsNavigationDelegate?
    let repository: PaymentRepository
    let orderAccessToken: AccessToken
    let order: Order
    var childViewModel: CardFormViewModel
    var cardPaymentFailure: ((Error?) -> Void)?
    
    
    init(repository: PaymentRepository, delegate: PaymentMethodsNavigationDelegate, orderAccessToken: AccessToken, order: Order) {
        self.repository = repository
        self.delegate = delegate
        self.orderAccessToken = orderAccessToken
        self.order = order
        self.childViewModel = CardFormViewModel(api: repository.api)
    }
    

    
    func createCardPayment(card: CardParameters) {
        repository.createCardPayment(orderAccessToken: orderAccessToken, cardParameters: card) { result in
            switch result {
            case .success(let payment):
                switch payment.status {
                case .succeeded:
                    self.delegate?.paymentMethodsDidSucceed()
                case .declined(let error):
                    self.delegate?.paymentMethodsDidFail(declineError: error)
                case .requiresAction(let action):
                    self.delegate?.paymentMethodsDidRequire3DSecure(action: action, payment: payment)
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

