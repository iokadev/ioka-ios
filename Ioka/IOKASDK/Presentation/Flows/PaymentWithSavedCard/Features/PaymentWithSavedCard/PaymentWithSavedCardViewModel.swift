//
//  PaymentWithSavedCardViewModel.swift
//  Ioka
//
//  Created by ablai erzhanov on 06.04.2022.
//

import Foundation


class PaymentWithSavedCardViewModel: ProgressViewModelProtocol {
    
    var delegate: PaymentWithSavedCardNavigationDelegate?
    var state: ProgressViewModelState
    var repository: OrderRepository
    var orderAccessToken: AccessToken
    
    init(delegate: PaymentWithSavedCardNavigationDelegate, repository: OrderRepository, orderAccessToken: AccessToken) {
        self.state = .progress
        self.delegate = delegate
        self.orderAccessToken = orderAccessToken
        self.repository = repository
    }
    
    func getOrder() {
        repository.getOrder(orderAccessToken: orderAccessToken) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let order):
                self.delegate?.dismissProgressWrappper(order)
            case .failure(let error):
                self.delegate?.dismissProgressWrapper(error)
            }
        }
        
    }
    
    
}
