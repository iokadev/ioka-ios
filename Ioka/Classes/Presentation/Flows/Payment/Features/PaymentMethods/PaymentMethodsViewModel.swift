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
    func paymentMethodsDidRequireThreeDSecure(action: Action, payment: Payment)
    func paymentMethodsDidFail(declineError: Error)
}


internal class PaymentMethodsViewModel {
    
    weak var delegate: PaymentMethodsNavigationDelegate?
    let repository: PaymentRepository
    let orderAccessToken: AccessToken
    let order: Order
    var cardFormViewModel: CardFormViewModel
    var applePayData: ApplePayData?
    
    init(delegate: PaymentMethodsNavigationDelegate, repository: PaymentRepository, orderAccessToken: AccessToken, order: Order, cardFormViewModel: CardFormViewModel, applePayData: ApplePayData?) {
        self.repository = repository
        self.delegate = delegate
        self.orderAccessToken = orderAccessToken
        self.order = order
        self.cardFormViewModel = cardFormViewModel
        self.applePayData = applePayData
    }
    
    func createCardPayment(card: CardParameters, completion: @escaping (Error?) -> Void) {
        repository.createCardPayment(orderAccessToken: orderAccessToken, cardParameters: card) { result in
            switch result {
            case .success(let payment):
                switch payment.status {
                case .succeeded:
                    self.delegate?.paymentMethodsDidSucceed()
                case .declined(let error):
                    self.delegate?.paymentMethodsDidFail(declineError: error)
                case .requiresAction(let action):
                    self.delegate?.paymentMethodsDidRequireThreeDSecure(action: action, payment: payment)
                }
                
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }

    func createApplePayPayment() {
        Ioka.shared.applePayPaymentRequest(orderAccessToken: orderAccessToken.token, applePayData: applePayData) { result in
            switch result {
            case .success(let status):
//                switch status {
//                case .
//                }
                self.delegate?.paymentMethodsDidSucceed()
            case .failure(let error):
                self.delegate?.paymentMethodsDidFail(declineError: error)
            }
        }
    }
}

