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

    init(repository: ApplePayRepository, orderAccessToken: AccessToken) {
        self.repository = repository
        self.orderAccessToken = orderAccessToken
    }


    func createPaymentToken(transactionId: String,paymentData: ApplePayPaymentData, paymentMethod: ApplePayPaymentMethod, completion: @escaping(ApplePayTokenResult) -> Void) {
        let createPaymentTokenParameters = CreatePaymentTokenParameters(apple_pay: ApplePayParameters(paymentData: paymentData, paymentMethod: paymentMethod, transactionIdentifier: transactionId))

        repository.createToolPayment(orderAccessToken: orderAccessToken, createPaymentTokenParameters: createPaymentTokenParameters) {  result in
            switch result {
            case .success(let payment):
                switch payment.status {
                case .succeeded:
                    completion(.succeed)
                case .declined(let apiError):
                    completion(.applePayDidFail(declineError: apiError))
                case .requiresAction(let action):
                    completion(.requiresAction(action: action, payment: payment))
                }
            case .failure(let error):
                completion(.failure(error: error))
            }
        }
    }
}
