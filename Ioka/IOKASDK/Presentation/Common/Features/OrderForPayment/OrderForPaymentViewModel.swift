//
//  OrderForPaymentViewModel.swift
//  Ioka
//
//  Created by ablai erzhanov on 06.04.2022.
//

import Foundation


class OrderForPaymentViewModel: ProgressViewModelProtocol {
    
    var delegate: PaymentMethodsNavigationDelegate?
    var state: ProgressViewModelState
    let repository: OrderRepository
    let orderAccessToken: AccessToken
    
    init(repository: OrderRepository, delegate: PaymentMethodsNavigationDelegate, orderAccessToken: AccessToken) {
        self.repository = repository
        self.state = .progress
        self.delegate = delegate
        self.orderAccessToken = orderAccessToken
    }
    
    func getOrder() {
        repository.getOrder(orderAccessToken: orderAccessToken) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let order):
                self.dismissProgressWrapperWithOrder(order)
            case .failure(let error):
                self.dismissProgressWrapperWithError(error)
            }
        }
    }
    
    func dismissProgressWrapperWithError(_ error: Error) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.delegate?.dismissProgressWrapper(error)
        })
    }
    
    func dismissProgressWrapperWithOrder(_ order: Order) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.delegate?.dismissProgressWrapper(order)
        })
    }
    
}
