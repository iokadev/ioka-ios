//
//  NetworkManager.swift
//  iOKA
//
//  Created by ablai erzhanov on 11.03.2022.
//

// REVIEW: IokaEndpoint, APIError, DTOs тоже в эту папку все пойдут. Всё, что относится к API Ioka - сюда. Всё по сети, что утилитарное, не зависящее от Ioka - в папку Infrastructure/Networking.

import Foundation

// REVIEW: лучше IokaAPI. Так как будем делать этот класс публичным.
class API: IokaAPIProtocol {
    
    let apiKey: APIKey
    
    private let endPointRouter = EndPointRouter<IokaApiEndPoint>()
    
    
    init(apiKey: APIKey) {
        self.apiKey = apiKey
    }
    
    func createCardPayment(orderAccessToken: AccessToken, card: Card, completion: @escaping (Result<CardPaymentResponse, Error>) -> Void) {
        endPointRouter.request(IokaApiEndPoint(apiKey: apiKey, endPoint: .createCardPayment(orderAccessToken: orderAccessToken, card: card)), completion: completion)
    }
    
    func getBrand(partialBin: String, completion: @escaping (Result<GetBrandResponse, Error>) -> Void) {
        endPointRouter.request(IokaApiEndPoint(apiKey: apiKey, endPoint: .getBrand(partialBin: partialBin)), completion: completion)
    }
    
    func getEmitterByBinCode(binCode: String, completion: @escaping (Result<GetEmitterByBinCodeResponse, Error>) -> Void) {
        endPointRouter.request(IokaApiEndPoint(apiKey: apiKey, endPoint: .getEmitterByBinCode(binCode: binCode)), completion: completion)
    }
    
    func getCards(customerAccessToken: AccessToken, completion: @escaping (Result<[GetCardResponse], Error>) -> Void) {
        endPointRouter.request(IokaApiEndPoint(apiKey: apiKey, endPoint: .getCards(customerAccessToken: customerAccessToken)), completion: completion)
    }
    
    func createBinding(customerAccessToken: AccessToken, card: Card, completion: @escaping (Result<GetCardResponse, Error>) -> Void) {
        endPointRouter.request(IokaApiEndPoint(apiKey: apiKey, endPoint: .createBinding(customerAccessToken: customerAccessToken, card: card)), completion: completion)
    }
    
    func deleteCard(customerAccessToken: AccessToken, cardId: String, completion: @escaping (Result<EmptyResponse, Error>) -> Void) {
        endPointRouter.request(IokaApiEndPoint(apiKey: apiKey, endPoint: .deleteCardByID(customerAccessToken: customerAccessToken, cardId: cardId)), completion: completion)
    }
    
    func getCardByID(customerAccessToken: AccessToken, cardId: String, completion: @escaping (Result<GetCardResponse, Error>) -> Void) {
        endPointRouter.request(IokaApiEndPoint(apiKey: apiKey, endPoint: .getCardByID(customerAccessToken: customerAccessToken, cardId: cardId)), completion: completion)
    }
    
    func getPaymentByID(orderAccessToken: AccessToken, paymentId: String, completion: @escaping (Result<CardPaymentResponse, Error>) -> Void) {
        endPointRouter.request(IokaApiEndPoint(apiKey: apiKey, endPoint: .getPaymentByID(orderAccessToken: orderAccessToken, paymentId: paymentId)), completion: completion)
    }
    
    func getOrderByID(orderAccessToken: AccessToken, completion: @escaping (Result<GetOrderResponse, Error>) -> Void) {
        endPointRouter.request(IokaApiEndPoint(apiKey: apiKey, endPoint: .getOrderByID(orderAccessToken: orderAccessToken)), completion: completion)
    }
}
