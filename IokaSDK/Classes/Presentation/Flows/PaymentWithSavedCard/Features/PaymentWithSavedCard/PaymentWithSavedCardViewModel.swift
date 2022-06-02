//
//  PaymentWithSavedCardViewModel.swift
//  Ioka
//
//  Created by ablai erzhanov on 06.04.2022.
//

import Foundation

protocol PaymentWithSavedCardNavigationDelegate: AnyObject {
    func paymentWithSavedCardDidReceiveOrder(_ order: Order)
    func paymentWithSavedCardDidRequireCVV()
    func paymentWithSavedCardDidRequireThreeDSecure(action: Action, payment: Payment)
    func paymentWithSavedCardDidSucceed()
    func paymentWithSavedCardDidFail(declineError: Error)
    func paymentWithSavedCardDidFail(otherError: Error)
}

internal class PaymentWithSavedCardViewModel: ProgressViewModelProtocol {
    
    weak var delegate: PaymentWithSavedCardNavigationDelegate?
    var state: ProgressViewModelState
    var repository: OrderRepository
    var orderAccessToken: AccessToken
    var card: SavedCard
    
    init(delegate: PaymentWithSavedCardNavigationDelegate, repository: OrderRepository, orderAccessToken: AccessToken, card: SavedCard) {
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
                self.delegate?.paymentWithSavedCardDidReceiveOrder(order)
                
                if self.card.cvvIsRequired {
                    self.executeAfterDelay {
                        self.delegate?.paymentWithSavedCardDidRequireCVV()
                    }
                } else {
                    self.makePayment(order: order)
                }
            case .failure(let error):
                self.executeAfterDelay {
                    self.delegate?.paymentWithSavedCardDidFail(otherError: error)
                }
            }
        }
    }
    
    func makePayment(order: Order) {
        repository.createPayment(orderAccessToken: orderAccessToken, card: card) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let payment):
                switch payment.status {
                case .succeeded:
                    self.delegate?.paymentWithSavedCardDidSucceed()
                case .declined(let error):
                    self.delegate?.paymentWithSavedCardDidFail(declineError: error)
                case .requiresAction(let action):
                    self.delegate?.paymentWithSavedCardDidRequireThreeDSecure(action: action, payment: payment)
                }
            case .failure(let error):
                self.delegate?.paymentWithSavedCardDidFail(otherError: error)
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
