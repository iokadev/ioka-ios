//
//  CreatePaymentForSavedCardViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 04.04.2022.
//

import Foundation

protocol CreatePaymentForSavedCardNavigationDelegate {
    func paymentCreated(response: CardPaymentResponse?, error: IokaError?, status: PaymentResult)
}


class CreatePaymentForSavedCardViewModel {
    
    var delegate: CreatePaymentForSavedCardNavigationDelegate?
    
    init(card: GetCardResponse, orderId: String, delegate: CreatePaymentForSavedCardNavigationDelegate) {
        self.delegate = delegate
        createPayment(card: card, orderId: orderId)
    }
    
    func createPayment(card: GetCardResponse, orderId: String) {
        let card = Card(cardId: card.id, cvc: nil)
        IokaApi.shared.createCardPayment(orderId: orderId, card: card) { [weak self] result, error in
            guard let self = self else { return }
            
            guard error == nil else {
                self.delegate?.paymentCreated(response: result, error: error, status: .paymentFailed)
                return
            }
            guard let result = result else { return }
            
            guard result.error == nil else {
                self.delegate?.paymentCreated(response: result, error: error, status: .paymentFailed)
                return
            }
            
            self.delegate?.paymentCreated(response: result, error: error, status: .paymentSucceed)
        }
    }
    
}
