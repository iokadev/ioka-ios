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
    var cardResponse: GetCardResponse?
    var orderId: String?
    
    init(cardResponse: GetCardResponse, orderId: String, delegate: CreatePaymentForSavedCardNavigationDelegate) {
        self.delegate = delegate
        self.cardResponse = cardResponse
        self.orderId = orderId
    }
    
    func createPayment() {
        guard let cardResponse = cardResponse, let orderId = orderId else { return }
        let card = Card(cardId: cardResponse.id, cvc: nil)
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
