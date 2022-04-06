//
//  IokaAPIProtocol.swift
//  IOKA
//
//  Created by Тимур Табынбаев on 05.04.2022.
//

import Foundation

// реализация IokaAPI тоже в эту папку пойдет

protocol IokaAPIProtocol {
    func createCardPayment(orderAccessToken: AccessToken, card: Card, completion: @escaping (Result<CardPaymentResponse, Error>) -> Void)
    func getBrand(partialBin: String, completion: @escaping (Result<GetBrandResponse, Error>) -> Void)
    func getEmitterByBinCode(binCode: String, completion: @escaping (Result<GetEmitterByBinCodeResponse, Error>) -> Void)
    func getCards(customerAccessToken: AccessToken, completion: @escaping (Result<[GetCardResponse], Error>) -> Void)
    func createBinding(customerAccessToken: AccessToken, card: Card, completion: @escaping (Result<GetCardResponse, Error>) -> Void)
    func deleteCard(customerAccessToken: AccessToken, cardId: String, completion: @escaping (Result<EmptyResponse, Error>) -> Void)
    func getCardByID(customerAccessToken: AccessToken, cardId: String, completion: @escaping (Result<GetCardResponse, Error>) -> Void)
    func getPaymentByID(orderAccessToken: AccessToken, paymentId: String, completion: @escaping (Result<CardPaymentResponse, Error>) -> Void)
    func getOrderByID(orderAccessToken: AccessToken, completion: @escaping (Result<GetOrderResponse, Error>) -> Void)
}
