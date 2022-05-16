//
//  NetworkManager.swift
//  iOKA
//
//  Created by ablai erzhanov on 11.03.2022.
//

import Foundation

public class IokaApi: IokaAPIProtocol {
    
    let apiKey: APIKey
    
    private let endpointRouter = EndpointRouter<IokaApiEndpoint>()
    
    
    init(apiKey: APIKey) {
        self.apiKey = apiKey
    }
    
    func createCardPayment(orderAccessToken: AccessToken, card: CardParameters, completion: @escaping (Result<PaymentDTO, Error>) -> Void) {
        endpointRouter.request(IokaApiEndpoint(apiKey: apiKey, endpoint: .createCardPayment(orderAccessToken: orderAccessToken, card: card)), completion: completion)
    }
    
    func getBrand(partialBin: String, completion: @escaping (Result<GetBrandResponse, Error>) -> Void) {
        endpointRouter.request(IokaApiEndpoint(apiKey: apiKey, endpoint: .getBrand(partialBin: partialBin)), completion: completion)
    }
    
    func getEmitterByBinCode(binCode: String, completion: @escaping (Result<EmitterDTO, Error>) -> Void) {
        endpointRouter.request(IokaApiEndpoint(apiKey: apiKey, endpoint: .getEmitterByBinCode(binCode: binCode)), completion: completion)
    }
    
    func getCards(customerAccessToken: AccessToken, completion: @escaping (Result<[SavedCardDTO], Error>) -> Void) {
        endpointRouter.request(IokaApiEndpoint(apiKey: apiKey, endpoint: .getCards(customerAccessToken: customerAccessToken)), completion: completion)
    }
    
    func createBinding(customerAccessToken: AccessToken, card: CardParameters, completion: @escaping (Result<SavedCardDTO, Error>) -> Void) {
        endpointRouter.request(IokaApiEndpoint(apiKey: apiKey, endpoint: .createBinding(customerAccessToken: customerAccessToken, card: card)), completion: completion)
    }
    
    func deleteCard(customerAccessToken: AccessToken, cardId: String, completion: @escaping (Result<EmptyResponse, Error>) -> Void) {
        endpointRouter.request(IokaApiEndpoint(apiKey: apiKey, endpoint: .deleteCardByID(customerAccessToken: customerAccessToken, cardId: cardId)), completion: completion)
    }
    
    func getCardByID(customerAccessToken: AccessToken, cardId: String, completion: @escaping (Result<SavedCardDTO, Error>) -> Void) {
        endpointRouter.request(IokaApiEndpoint(apiKey: apiKey, endpoint: .getCardByID(customerAccessToken: customerAccessToken, cardId: cardId)), completion: completion)
    }
    
    func getPaymentByID(orderAccessToken: AccessToken, paymentId: String, completion: @escaping (Result<PaymentDTO, Error>) -> Void) {
        endpointRouter.request(IokaApiEndpoint(apiKey: apiKey, endpoint: .getPaymentByID(orderAccessToken: orderAccessToken, paymentId: paymentId)), completion: completion)
    }
    
    func getOrderByID(orderAccessToken: AccessToken, completion: @escaping (Result<OrderDTO, Error>) -> Void) {
        endpointRouter.request(IokaApiEndpoint(apiKey: apiKey, endpoint: .getOrderByID(orderAccessToken: orderAccessToken)), completion: completion)
    }

    func createPaymentToken(orderAccessToken: AccessToken, createPaymentTokenParameters: CreatePaymentTokenParameters, completion: @escaping (Result<PaymentDTO, Error>) -> Void) {
        endpointRouter.request(IokaApiEndpoint(apiKey: apiKey, endpoint: .createPaymentToken(orderAccessToken: orderAccessToken, createPaymentTokenParameters: createPaymentTokenParameters)), completion: completion)
    }
}
