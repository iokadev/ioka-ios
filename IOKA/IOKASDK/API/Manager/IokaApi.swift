//
//  NetworkManager.swift
//  iOKA
//
//  Created by ablai erzhanov on 11.03.2022.
//

import Foundation

class IokaApi {
    
    static let environment: NetworkEnvironment = .stage
    static let shared = IokaApi()
    
    private let endPointRouter = EndPointRouter<IokaApiEndPoint>()
    
    // Сюда надо передавать orderAccessToken. Нельзя внутри IokaEndpoint лезть в фасад Ioka. Так получается бардак со связями между слоями.
    func createCardPayment(orderId: String, card: Card, completion: @escaping (Result<CardPaymentResponse, Error>) -> Void) {
        endPointRouter.request(
            .createCardPayment(orderId: orderId,
                               card: card),
            completion: completion)
    }
    
    func getBrand(partialBin: String, completion: @escaping (Result<GetBrandResponse, Error>) -> Void) {
        endPointRouter.request(
            .getBrand(partialBin: partialBin),
            completion: completion)
    }
    
    func getEmitterByBinCode(binCode: String, completion: @escaping (Result<GetEmitterByBinCodeResponse, Error>) -> Void) {
        endPointRouter.request(
            .getEmitterByBinCode(binCode: binCode),
            completion: completion)
    }
    
    func getCards(customerId: String, completion: @escaping (Result<GetCardResponse, Error>) -> Void) {
        endPointRouter.request(
            .getCards(customerId: customerId),
            completion: completion)
    }
    
    func createBinding(customerId: String, card: Card, completion: @escaping (Result<GetCardResponse, Error>) -> Void) {
        endPointRouter.request(
            .createBinding(customerId: customerId, card: card),
            completion: completion)
    }
    
    func deleteCard(customerId: String, cardId: String, completion: @escaping (Result<EmptyResponse, Error>) -> Void) {
        endPointRouter.request(
            .deleteCardByID(customerId: customerId, cardId: cardId),
            completion: completion)
    }
    
    func getCardByID(customerId: String, cardId: String, completion: @escaping (Result<GetCardResponse, Error>) -> Void) {
        endPointRouter.request(
            .getCardByID(customerId: customerId, cardId: cardId),
            completion: completion)
    }
    
    func getPaymentByID(orderId: String, paymentId: String, completion: @escaping (Result<CardPaymentResponse, Error>) -> Void) {
        endPointRouter.request(
            .getPaymentByID(orderId: orderId, paymentId: paymentId),
            completion: completion)
    }
    
    func getOrderByID(orderId: String, completion: @escaping (Result<GetOrderResponse, Error>) -> Void) {
        endPointRouter.request(
            .getOrderByID(orderId: orderId),
            completion: completion)
    }
}
