//
//  3DSecureViewModel.swift
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

internal enum ThreeDSecureState {
    case saveCard(repository: SavedCardRepository, customerAccessToken: AccessToken)
    case payment(repository: PaymentRepository, orderAccessToken: AccessToken)
}


internal class ThreeDSecureViewModel {
    
    weak var delegate: ThreeDSecureNavigationDelegate?
    var state: ThreeDSecureState
    var cardId: String?
    var paymentId: String?
    
    var showError: ((Error) -> Void)?
    
    init(delegate: ThreeDSecureNavigationDelegate, state: ThreeDSecureState, cardId: String?, paymentId: String?) {
        self.delegate = delegate
        self.state = state
        self.cardId = cardId
        self.paymentId = paymentId
    }
    
    func handleRedirect() {
        switch state {
        case .saveCard(let repository, let customerAccessToken):
            guard let cardId = cardId else { return }
            getSavedCard(repository: repository, customerAccessToken: customerAccessToken, cardId: cardId)
        case .payment(let repository, let orderAccessToken):
            guard let paymentId = paymentId else { return }
            getPayment(repository: repository, orderAccessToken: orderAccessToken, paymentId: paymentId)
        }
    }
    
    func isReturnUrl(_ url: URL?) -> Bool {
        url == URL(string: "https://ioka.kz/")
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
