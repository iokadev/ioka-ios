//
//  ApplePayViewModel.swift
//  Ioka
//
//  Created by ablai erzhanov on 13.05.2022.
//

import Foundation

internal protocol ApplePayNavigationDelegate: AnyObject {
    func applePayDidCancel()
    func applePayDidSucceed()
    func applePayRequiresAction(action: Action, payment: Payment)
    func applePayDidFail(declineError: Error)

    func applePayDismiss()
    func errorForResult(error: Error)
}


internal class ApplePayViewModel {

    let repository: ApplePayRepository
    let orderAccessToken: AccessToken

    weak var delegate: ApplePayNavigationDelegate?

    init(repository: ApplePayRepository, orderAccessToken: AccessToken, delegate: ApplePayNavigationDelegate) {
        self.repository = repository
        self.orderAccessToken = orderAccessToken
        self.delegate = delegate
    }

    func dismissApplePay() {
        delegate?.applePayDismiss()
    }

    func createPaymentToken() {
        let createPaymentTokenParameters = CreatePaymentTokenParameters(apple_pay: ApplePayParameters.defaultValue)
        repository.createToolPayment(orderAccessToken: orderAccessToken, createPaymentTokenParameters: createPaymentTokenParameters) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let payment):
                switch payment.status {
                case .succeeded:
                    self.delegate?.applePayDidSucceed()
                case .declined(let apiError):
                    self.delegate?.applePayDidFail(declineError: apiError)
                case .requiresAction(let action):
                    self.delegate?.applePayRequiresAction(action: action, payment: payment)
                }
            case .failure(let error):
                self.delegate?.errorForResult(error: error)
            }
        }
    }
}
