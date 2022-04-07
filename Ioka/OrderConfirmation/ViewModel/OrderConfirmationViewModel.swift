//
//  OrderConfirmationViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import Foundation


class OrderConfirmationViewModel {
    
    
    func createOrder(order: OrderModel, completion: @escaping(String) -> Void) {
        DemoAppApi.shared.createOrder(price: order.orderPrice) { [weak self] result in
            guard let _ = self else { return }
            
            switch result {
            case .success(let createOrderResponse):
                completion(createOrderResponse.order_access_token)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getProfile(completion: @escaping(String?) -> Void) {
        DemoAppApi.shared.getProfile { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let createOrderResponse):
                completion(createOrderResponse.customer_access_token)
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func getSavedCards(customerAccessToken: String, completion: @escaping([GetCardResponse]?, IokaError?) -> Void) {
        Ioka.shared.getCards(customerAccessToken: customerAccessToken) { [weak self] result in
            guard let _ = self else { return }
            switch result {
            case .success(let cards):
                completion(cards, nil)
            case .failure(let error):
                completion(nil, error)
            }
            
        }
    }
}
