//
//  ThreeDSecureViewModel.swift
//  Ioka
//
//  Created by ablai erzhanov on 06.04.2022.
//

import Foundation

internal protocol ThreeDSecureNavigationDelegate: AnyObject {
    func threeDSecureDidSucceed()
    func threeDSecureDidFail(declinedError: Error)
    func threeDSecureDidFail(otherError: Error)
    func threeDSecureDidCancel()
}

internal enum ThreeDSecureInput {
    case saveCard(repository: SavedCardRepository, customerAccessToken: AccessToken, cardId: String)
    case payment(repository: PaymentRepository, orderAccessToken: AccessToken, paymentId: String)
}


internal class ThreeDSecureViewModel {
    
    weak var delegate: ThreeDSecureNavigationDelegate?
    let action: Action
    let input: ThreeDSecureInput
    
    init(delegate: ThreeDSecureNavigationDelegate, action: Action, input: ThreeDSecureInput) {
        self.delegate = delegate
        self.action = action
        self.input = input
    }
    
    func handleRedirect() {
        switch input {
        case .saveCard(let repository, let customerAccessToken, let cardId):
            getSavedCard(repository: repository, customerAccessToken: customerAccessToken, cardId: cardId)
        case .payment(let repository, let orderAccessToken, let paymentId):
            getPayment(repository: repository, orderAccessToken: orderAccessToken, paymentId: paymentId)
        }
    }
    
    func isReturnUrl(_ url: URL?) -> Bool {
        url == URL(string: action.returnUrl)
    }
    
    func close() {
        delegate?.threeDSecureDidCancel()
    }
    
    private func getSavedCard(repository: SavedCardRepository, customerAccessToken: AccessToken, cardId: String) {
        repository.getStatus(customerAccessToken: customerAccessToken, cardId: cardId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let cardSaving):
                switch cardSaving.status {
                case .succeeded:
                    self.delegate?.threeDSecureDidSucceed()
                case .declined(let error):
                    self.delegate?.threeDSecureDidFail(declinedError: error)
                default:
                    self.delegate?.threeDSecureDidCancel()
                }
            case .failure(let error):
                self.delegate?.threeDSecureDidFail(otherError: error)
            }
        }
    }
    
    private func getPayment(repository: PaymentRepository, orderAccessToken: AccessToken, paymentId: String) {
        repository.getStatus(orderAccessToken: orderAccessToken, paymentId: paymentId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let payment):
                switch payment.status {
                case .succeeded:
                    self.delegate?.threeDSecureDidSucceed()
                case .declined(let error):
                    self.delegate?.threeDSecureDidFail(declinedError: error)
                default:
                    self.delegate?.threeDSecureDidCancel()
                }
            case .failure(let error):
                self.delegate?.threeDSecureDidFail(otherError: error)
            }
        }
    }
}
