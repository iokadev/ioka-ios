//
//  IokaAPIProtocol.swift
//  IOKA
//
//  Created by Тимур Табынбаев on 05.04.2022.
//

import Foundation

// реализация IokaAPI тоже в эту папку пойдет

protocol IokaAPIProtocol {
    func createCardPayment(orderId: String, card: Card, completion: @escaping (Result<CardPaymentResponse, Error>) -> Void)
    func getBrand(partialBin: String, completion: @escaping (Result<GetBrandResponse, Error>) -> Void)
    func getEmitterByBinCode(binCode: String, completion: @escaping (Result<GetEmitterByBinCodeResponse, Error>) -> Void)
    func getCards(customerId: String, completion: @escaping (Result<GetCardResponse, Error>) -> Void)
    func createBinding(customerId: String, card: Card, completion: @escaping (Result<GetCardResponse, Error>) -> Void)
    func deleteCard(customerId: String, cardId: String, completion: @escaping (Result<EmptyResponse, Error>) -> Void)
    func getCardByID(customerId: String, cardId: String, completion: @escaping (Result<GetCardResponse, Error>) -> Void)
    func getPaymentByID(orderId: String, paymentId: String, completion: @escaping (Result<CardPaymentResponse, Error>) -> Void)
    func getOrderByID(orderId: String, completion: @escaping (Result<GetOrderResponse, Error>) -> Void)
}
