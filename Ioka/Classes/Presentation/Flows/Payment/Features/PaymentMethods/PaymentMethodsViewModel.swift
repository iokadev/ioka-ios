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
    var cardPaymentFailure: ((Error?) -> Void)?
    
    
    init(delegate: PaymentMethodsNavigationDelegate, repository: PaymentRepository, orderAccessToken: AccessToken, order: Order, cardFormViewModel: CardFormViewModel) {
        self.repository = repository
        self.delegate = delegate
        self.orderAccessToken = orderAccessToken
        self.order = order
        self.cardFormViewModel = cardFormViewModel
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
                    self.delegate?.paymentMethodsDidRequireThreeDSecure(action: action, payment: payment)
                }
            case .failure(let error):
                self.cardPaymentFailure?(error)
            }
        }
    }
}

