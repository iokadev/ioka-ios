//
//  ApplePayRepository.swift
//  Ioka
//
//  Created by ablai erzhanov on 17.05.2022.
//

import Foundation

final class ApplePayRepository {
    private let api: IokaAPIProtocol

    init(api: IokaAPIProtocol) {
        self.api = api
    }

    func createToolPayment(orderAccessToken: AccessToken, createPaymentTokenParameters: CreatePaymentTokenParameters, completion: @escaping(Result<PaymentDTO, Error>) -> Void) {
        api.createPaymentToken(orderAccessToken: orderAccessToken, createPaymentTokenParameters: createPaymentTokenParameters, completion: completion)
    }
}
