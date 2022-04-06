//
//  OrderRepository.swift
//  Ioka
//
//  Created by ablai erzhanov on 06.04.2022.
//

import Foundation


final class OrderRepository {
    private let api: IokaAPIProtocol
    
    
    init(api: IokaAPIProtocol) {
        self.api = api
    }
    
    func getOrder(orderAccessToken: AccessToken, completion: @escaping(Result<Order, Error>) -> Void) {
        api.getOrderByID(orderAccessToken: orderAccessToken) { result in
            completion(result.toOrderResult())
        }
    }
}


extension Result where Success == GetOrderResponse {
    func toOrderResult() -> Result<Order, Error> {
        Result<Order, Error> {
            switch self {
            case .success(let response):
                return try response.toOrder()
            case .failure(let error):
                throw error
            }
        }
    }
}
