//
//  CVVViewModel.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import Foundation

protocol CVVNavigationDelegate: AnyObject {
    func cvvDidRequireThreeDSecure(action: Action, payment: Payment)
    func cvvDidSucceed()
    func cvvDidFail(declineError: Error)
    func cvvDidFail(otherError: Error)
    func cvvDidCancel()
}

internal class CVVViewModel {
    
    weak var delegate: CVVNavigationDelegate?
    
    let repository: PaymentRepository
    let orderCustomerAccessToken: AccessToken
    
    init(delegate: CVVNavigationDelegate?, repository: PaymentRepository, orderAccessToken: AccessToken) {
        self.delegate = delegate
        self.repository = repository
        self.orderCustomerAccessToken = orderAccessToken
    }
    
    func createPayment(cardParameters: CardParameters) {
        repository.createCardPayment(orderAccessToken: orderCustomerAccessToken, cardParameters: cardParameters) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let payment):
                switch payment.status {
                case .succeeded:
                    self.delegate?.cvvDidSucceed()
                case .declined(let error):
                    self.delegate?.cvvDidFail(declineError: error)
                case .requiresAction(let action):
                    self.delegate?.cvvDidRequireThreeDSecure(action: action, payment: payment)
                }
            case .failure(let error):
                self.delegate?.cvvDidFail(otherError: error)
            }
        }
    }
    
    func close() {
        delegate?.cvvDidCancel()
    }
}

