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
    var card: GetCardResponse
    
    init(delegate: PaymentWithSavedCardNavigationDelegate, repository: OrderRepository, orderAccessToken: AccessToken, card: GetCardResponse) {
        self.state = .progress
        self.delegate = delegate
        self.orderAccessToken = orderAccessToken
        self.repository = repository
        self.card = card
    }
    
    func getOrder() {
        repository.getOrder(orderAccessToken: orderAccessToken) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let order):
                if self.card.cvc_required {
                    self.dismissProgressWrapperWithOrder(order, apiError: nil)
                } else {
                    self.makePayment(order: order)
                }
            case .failure(let error):
                self.dismissProgressWrapperWithError(error)
            }
        }
    }
    
    func makePayment(order: Order) {
        repository.createPayment(orderAccessToken: orderAccessToken, card: card) { result in
            switch result {
            case .success(let payment):
                switch payment.status {
                case .succeeded:
                    self.dismissProgressWrapperWithOrder(order, apiError: nil)
                case .declined(let apiError):
                    self.dismissProgressWrapperWithOrder(order, apiError: apiError)
                case .requiresAction(let action):
                    self.dismissProgressWrapperWithOrder(order, apiError: nil)
                    self.delegate?.showThreeDSecure(action, payment: payment)
                }
            case .failure(let error):
                self.dismissProgressWrapperWithError(error)
            }
        }
    }
    
    private func dismissProgressWrapperWithError(_ error: Error) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.delegate?.dismissProgressWrapper(error)
        })
    }
    
    private func dismissProgressWrapperWithOrder(_ order: Order, apiError: APIError?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
            self.delegate?.dismissProgressWrapper(order, isCVVRequired: self.card.cvc_required, apiError: apiError)
        })
    }
    
    
}
