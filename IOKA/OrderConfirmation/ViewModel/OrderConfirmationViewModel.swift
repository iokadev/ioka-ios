//
//  OrderConfirmationViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 25.03.2022.
//

import Foundation


class OrderConfirmationViewModel {
    
    
    func createOrder(order: OrderModel, completion: @escaping(String) -> Void) {
        DemoAppApi.shared.createOrder(price: order.orderPrice) { createOrderResponse in
            if let createOrderResponse = createOrderResponse {
                DispatchQueue.main.async {
                    completion(createOrderResponse.order_access_token)
                }
                
            }
        }
    }
    
    func getProfile(completion: @escaping(String?) -> Void) {
        DemoAppApi.shared.getProfile { result, error in
            completion(result?.customer_access_token)
        }
    }
    
    func getSavedCards(customerAccessToken: String, completion: @escaping([GetCardResponse]?, IokaError?) -> Void) {
        IOKA.shared.getCards(customerAccessToken: customerAccessToken) { [weak self] result in
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
