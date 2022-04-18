//
//  OrderForPaymentViewModel.swift
//  Ioka
//
//  Created by ablai erzhanov on 06.04.2022.
//

import Foundation

protocol OrderForPaymentNavigationDelegate: AnyObject {
    func orderForPaymentDidReceiveOrder(order: Order)
    func orderForPaymentDidFail(error: Error)
}

 internal class OrderForPaymentViewModel: ProgressViewModelProtocol {
    
    weak var delegate: OrderForPaymentNavigationDelegate?
    var state: ProgressViewModelState
    let repository: OrderRepository
    let orderAccessToken: AccessToken
    
    init(repository: OrderRepository, delegate: OrderForPaymentNavigationDelegate, orderAccessToken: AccessToken) {
        self.repository = repository
        self.state = .progress
        self.delegate = delegate
        self.orderAccessToken = orderAccessToken
    }
    
    func getOrder() {
        repository.getOrder(orderAccessToken: orderAccessToken) { [weak self] result in
            guard let self = self else { return }
            self.executeAfterDelay {
                switch result {
                case .success(let order):
                    self.delegate?.orderForPaymentDidReceiveOrder(order: order)
                case .failure(let error):
                    self.delegate?.orderForPaymentDidFail(error: error)
                }
            }
        }
    }
     
     // в некоторых случаях индикатор прогресса слишком быстро исчезает, поэтому делаем задержку
     private func executeAfterDelay(_ handler: @escaping () -> Void) {
         DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
             handler()
         }
     }
}
