//
//  IokaAPIProtocol.swift
//  IOKA


import Foundation


internal protocol IokaAPIProtocol {
    func createCardPayment(orderAccessToken: AccessToken, card: CardParameters, completion: @escaping (Result<PaymentDTO, Error>) -> Void)
    func getBrand(partialBin: String, completion: @escaping (Result<GetBrandResponse, Error>) -> Void)
    func getEmitterByBinCode(binCode: String, completion: @escaping (Result<GetEmitterByBinCodeResponse, Error>) -> Void)
    func getCards(customerAccessToken: AccessToken, completion: @escaping (Result<[SavedCardDTO], Error>) -> Void)
    func createBinding(customerAccessToken: AccessToken, card: CardParameters, completion: @escaping (Result<SavedCardDTO, Error>) -> Void)
    func deleteCard(customerAccessToken: AccessToken, cardId: String, completion: @escaping (Result<EmptyResponse, Error>) -> Void)
    func getCardByID(customerAccessToken: AccessToken, cardId: String, completion: @escaping (Result<SavedCardDTO, Error>) -> Void)
    func getPaymentByID(orderAccessToken: AccessToken, paymentId: String, completion: @escaping (Result<PaymentDTO, Error>) -> Void)
    func getOrderByID(orderAccessToken: AccessToken, completion: @escaping (Result<OrderDTO, Error>) -> Void)
}
