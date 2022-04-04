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
        IokaApi.shared.createCardPayment(orderId: orderId, card: card) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let cardPaymentResponse):
                if let error = cardPaymentResponse.error {
                    self.handlePayment(response: cardPaymentResponse, error: error, status: .paymentFailed)
                } else {
                    self.handlePayment(response: cardPaymentResponse, error: nil, status: .paymentSucceed)
                }
            case .failure(let error):
                self.handlePayment(response: nil, error: error, status: .paymentFailed)
            }
        }
    }
    
    private func handlePayment(response: CardPaymentResponse?, error: IokaError?, status: PaymentResult) {
        DispatchQueue.main.async {
            self.delegate?.paymentCreated(response: response, error: error, status: status)
        }
    }
    
}
