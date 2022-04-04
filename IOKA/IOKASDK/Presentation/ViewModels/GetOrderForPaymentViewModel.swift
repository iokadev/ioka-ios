//
//  GetOrderForPaymentViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 04.04.2022.
//

import Foundation

protocol GetOrderForPaymentNavigationDelegate {
    func gotOrder(order: GetOrderResponse?, error: IokaError?)
}

class GetOrderForPaymentViewModel {
    var delegate: GetOrderForPaymentNavigationDelegate?
    var orderId: String?
    
    init(delegate: GetOrderForPaymentNavigationDelegate, orderId: String) {
        self.delegate = delegate
        self.orderId = orderId
    }
    
    func getOrder() {
        guard let orderId = orderId else { return }
        IokaApi.shared.getOrderByID(orderId: orderId) {[weak self] result, error in
            guard let self = self else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                self.delegate?.gotOrder(order: result, error: error)
            }
            
        }
    }
}
