//
//  PaymentRepository.swift
//  IOKA
//
//  Created by Тимур Табынбаев on 04.04.2022.
//

import Foundation

final class PaymentRepository {
    private let api: IokaAPIProtocol
    
    init(api: IokaAPIProtocol) {
        self.api = api
    }
    
    func createCardPayment(orderAccessToken: AccessToken, cardParameters: Card, completion: @escaping (Result<Payment, Error>) -> Void) {
        api.createCardPayment(orderId: orderAccessToken.id /* здесь должен передаваться сам accessToken */,
                              card: cardParameters) { result in
            completion(result.toPaymentResult())
        }
    }
    
    func createSavedCardPayment(orderAccessToken: AccessToken, cardParameters: Card, completion: @escaping (Result<Payment, Error>) -> Void) {
        api.createCardPayment(orderId: orderAccessToken.id, card: cardParameters) { result in
            completion(result.toPaymentResult())
        }
    }
    
    func getStatus(orderAccessToken: AccessToken, paymentId: String, completion: @escaping (Result<Payment, Error>) -> Void) {
        api.getPaymentByID(orderId: orderAccessToken.id, paymentId: paymentId) { result in
            completion(result.toPaymentResult())
        }
    }
}

extension Result where Success == CardPaymentResponse {
    func toPaymentResult() -> Result<Payment, Error> {
        Result<Payment, Error> {
            switch self {
            case .success(let response):
                return try response.toPayment()
            case .failure(let error):
                throw error
            }
        }
    }
}
