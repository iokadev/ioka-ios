//
//  CVVViewModel.swift
//  Ioka
//
//  Created by ablai erzhanov on 05.04.2022.
//

import Foundation

protocol PaymentWithSavedCardNavigationDelegate: NSObject {
    func showProgressWrapper()
    func showCVVForm()
    func showThreeDSecure(_ action: Action, payment: Payment)
    func showPaymentResult()
    func showPaymentResult(apiError: APIError)
    func showPaymentResult(error: Error)
    func dismissProgressWrapper(_ error: Error)
    func dismissProgressWrappper(_ order: Order)
    func dismissCVVForm()
    func dismissCVVForm(error: Error)
    func dismissCVVForm(apiError: Error)
    func dismissPaymentResult()
    func dismissErrorPopup()
}


class CVVViewModel {
    
    var delegate: PaymentWithSavedCardNavigationDelegate?
    
    let repository: PaymentRepository
    let orderCustomerAccessToken: AccessToken
    
    init(delegate: PaymentWithSavedCardNavigationDelegate?, repository: PaymentRepository, orderAccessToken: AccessToken) {
        self.delegate = delegate
        self.repository = repository
        self.orderCustomerAccessToken = orderAccessToken
    }
    
    func createPayment(cardParameters: Card) {
        repository.createSavedCardPayment(orderAccessToken: orderCustomerAccessToken, cardParameters: cardParameters) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let payment):
                switch payment.status {
                case .succeeded:
                    self.delegate?.dismissCVVForm()
                    self.delegate?.showPaymentResult()
                case .declined(let apiError):
                    self.delegate?.dismissCVVForm()
                    self.delegate?.showPaymentResult(apiError: apiError)
                case .requiresAction(let action):
                    self.delegate?.dismissCVVForm()
                    self.delegate?.showThreeDSecure(action, payment: payment)
                }
            case .failure(let error):
                self.delegate?.dismissCVVForm()
                self.delegate?.showPaymentResult(error: error)
            }
        }
    }
}

