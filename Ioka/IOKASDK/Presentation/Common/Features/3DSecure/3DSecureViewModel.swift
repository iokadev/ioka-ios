//
//  3DSecureViewModel.swift
//  Ioka
//
//  Created by ablai erzhanov on 06.04.2022.
//

import Foundation

protocol ThreeDSecureNavigationDelegate {
    // REVIEW: предлагаю по-другому делать методы в NavigationDelegate-ах - сделать методы, сообщающие о событиях: типа didSomething().
    // Здесь будет didFinishThreeDSecure(error: Error?) и didCloseThreeDSecure()
    // Для PaymentMethodsNavigationDelegate это будет didFinishPayment(error: Error?), didClosePaymentMethods(), didRequireThreeDSecure(action: Action)
    func dismissThreeDSecure()
    func dismissThreeDSecure(payment: Payment)
    func dismissThreeDSecure(apiError: APIError)
    func dismissThreeDSecure(error: Error)
    func dismissThreeDSecure(savedCard: SavedCard)
}

// REVIEW: State -> Input
enum ThreeDSecureState {
    case saveCard(repository: SavedCardRepository, customerAccessToken: AccessToken)
    case payment(repository: PaymentRepository, orderAccessToken: AccessToken)
}


class ThreeDSecureViewModel {
    
    var delegate: ThreeDSecureNavigationDelegate?
    var state: ThreeDSecureState
    
    // REVIEW: эти параметры в State(Input) нельзя положить?
    var cardId: String?
    var paymentId: String?
    
    
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
    
    private func getSavedCard(repository: SavedCardRepository, customerAccessToken: AccessToken, cardId: String) {
        repository.getStatus(customerAccessToken: customerAccessToken, cardId: cardId) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let savedCard):
                switch savedCard.status {
                case .succeeded:
                    self.delegate?.dismissThreeDSecure(savedCard: savedCard)
                case .declined(let apiError):
                    self.delegate?.dismissThreeDSecure(apiError: apiError)
                default:
                    self.delegate?.dismissThreeDSecure()
                }
            case .failure(let error):
                // REVIEW: if error is APIError self.delegate.didFinish3DSecure(error: error) else show toast. Внизу так же.
                self.delegate?.dismissThreeDSecure(error: error)
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
                    self.delegate?.dismissThreeDSecure(payment: payment)
                case .declined(let apiError):
                    self.delegate?.dismissThreeDSecure(apiError: apiError)
                default:
                    self.delegate?.dismissThreeDSecure()
                }
            case .failure(let error):
                self.delegate?.dismissThreeDSecure(error: error)
            }
        }
    }
}
