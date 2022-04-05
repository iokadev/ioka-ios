//
//  CreatePaymentForSavedCardViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 04.04.2022.
//

import Foundation

protocol CreatePaymentForSavedCardNavigationDelegate {
    func paymentCreated(orderResponse: GetOrderResponse, paymentResponse: CardPaymentResponse?, error: IokaError?, status: PaymentResult)
    func dismissCreatePaymentProgressWrapper()
}


class CreatePaymentForSavedCardViewModel {
    
    var delegate: CreatePaymentForSavedCardNavigationDelegate?
    var cardResponse: GetCardResponse?
    var orderId: String?
    var orderResponse: GetOrderResponse?
    var orderErrorCallBack: ((IokaError) -> Void)?
    
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
            guard let orderResponse = self.orderResponse else { return }

            switch result {
            case .success(let cardPaymentResponse):
                if let error = cardPaymentResponse.error {
                    self.handlePayment(orderResponse: orderResponse, paymentResponse: cardPaymentResponse, error: error, status: .paymentFailed)
                } else {
                    self.handlePayment(orderResponse: orderResponse, paymentResponse: cardPaymentResponse, error: nil, status: .paymentSucceed)
                }
            case .failure(let error):
                self.orderErrorCallBack?(error)
            }
        }
    }
    
    func getOrder() {
        guard let orderId = orderId else { return }
        IokaApi.shared.getOrderByID(orderId: orderId) {[weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let orderResponse):
                self.orderResponse = orderResponse
                self.createPayment()
            case .failure(let error):
                self.orderErrorCallBack?(error)
            }
        }
    }
    
    private func handlePayment(orderResponse: GetOrderResponse, paymentResponse: CardPaymentResponse?, error: IokaError?, status: PaymentResult) {
        DispatchQueue.main.async {
            self.delegate?.paymentCreated(orderResponse: orderResponse, paymentResponse: paymentResponse, error: error, status: status)
        }
    }
    
}
