//
//  GetOrderForPaymentViewModel.swift
//  IOKA
//
//  Created by ablai erzhanov on 04.04.2022.
//

import Foundation

protocol GetOrderForPaymentNavigationDelegate {
    func gotOrder(order: GetOrderResponse?, error: IokaError?)
    func dismissGetOrderProgressWrapper()
}

class GetOrderForPaymentViewModel {
    var delegate: GetOrderForPaymentNavigationDelegate?
    var orderId: String?
    var orderErrorCallBack: ((IokaError) -> Void)?
    
    init(delegate: GetOrderForPaymentNavigationDelegate, orderId: String) {
        self.delegate = delegate
        self.orderId = orderId
    }
    
    func prepareOrder(order: GetOrderResponse?, error: IokaError?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
            self.delegate?.gotOrder(order: order, error: error)
        }
    }
    
    func getOrder() {
        guard let orderId = orderId else { return }
        IokaApi.shared.getOrderByID(orderId: orderId) {[weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let orderResponse):
                self.prepareOrder(order: orderResponse, error: nil)
            case .failure(let error):
                self.orderErrorCallBack?(error)
            }
        }
    }
}
