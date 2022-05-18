//
//  ApplePayViewModel.swift
//  Ioka
//
//  Created by ablai erzhanov on 13.05.2022.
//

import Foundation


internal class ApplePayViewModel {

    let repository: ApplePayRepository
    let orderAccessToken: AccessToken
    let paymentData: ApplePayPaymentData
    let paymentMethod: ApplePayPaymentMethod
    let transactionID: String

    init(repository: ApplePayRepository, orderAccessToken: AccessToken, applePayParameters: ApplePayParameters) {
        self.repository = repository
        self.orderAccessToken = orderAccessToken
        self.paymentData = applePayParameters.paymentData
        self.paymentMethod = applePayParameters.paymentMethod
        self.transactionID = applePayParameters.transactionIdentifier
    }

    func createPaymentToken(completion: @escaping(Result<PaymentDTO, Error>) -> Void) {
        let createPaymentTokenParameters = CreatePaymentTokenParameters(apple_pay: ApplePayParameters(paymentData: paymentData, paymentMethod: paymentMethod, transactionIdentifier: transactionID))
        repository.createToolPayment(orderAccessToken: orderAccessToken, createPaymentTokenParameters: createPaymentTokenParameters, completion: completion)
    }
    
}
